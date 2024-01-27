-- SET Serveroutput ON; -- I was using DataGrip, SET Serveroutput ON does not work there. You are to enable DBMS output manually in DataGrip!
-- TRIGGER1
CREATE OR REPLACE TRIGGER TRIGGER1
BEFORE INSERT
ON Episode
FOR EACH ROW
DECLARE lastSeason NUMBER; lastEpisode NUMBER; lastReleaseDate DATE; isCompleted NUMBER;
BEGIN
    SELECT IsFinished INTO isCompleted FROM Series WHERE SeriesID = :new.SeriesID;

    IF isCompleted = 0 THEN -- checking if the series, to which episode is being added, is completed

        SELECT MAX(Season) INTO lastSeason FROM Episode WHERE SeriesID = :new.SeriesID; -- getting the last season of the series

        IF (lastSeason IS NULL AND :new.Season = 1) OR :new.Season = lastSeason OR :new.Season = lastSeason + 1 THEN -- checking if the season is the last season, next season (in case we are adding the first episode of the season) or the first season (in case we are adding episode to series that has no episodes yet) [user cannot add episode to already completed season]

            SELECT MAX(EpisodeInSeason) INTO lastEpisode FROM Episode WHERE SeriesID = :new.SeriesID AND Season = :new.Season; -- getting the last episode of the season

            IF (lastEpisode IS NULL AND :new.EpisodeInSeason = 1) OR :new.EpisodeInSeason = lastEpisode + 1 THEN -- checking if the episode is the first ar the next in the season

                    SELECT MAX(ReleaseDate) INTO lastReleaseDate FROM Episode WHERE SeriesID = :new.SeriesID; -- getting the latest episode release date

                    IF lastReleaseDate IS NOT NULL AND :new.ReleaseDate < lastReleaseDate THEN -- if the release date is bigger than the latest one
                        RAISE_APPLICATION_ERROR(-20100, 'Release date cannot be smaller than release date of already added episodes to the TV show!');
                    END IF;
            ELSE
                RAISE_APPLICATION_ERROR(-20100, 'You can only add next episode for the current season or the first episode for a new season!');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20100, 'You can only add episode to the current season, the next season or the first season (if the TV show has no episodes yet)!');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20100, 'You cannot add an episode to a finished TV show!');
    END IF;
END;

-- TRIGGER2
CREATE OR REPLACE TRIGGER TRIGGER2
BEFORE INSERT OR UPDATE OR DELETE
ON Watched
FOR EACH ROW
DECLARE age NUMBER; ageLimit NUMBER;
BEGIN
    IF UPDATING THEN
        RAISE_APPLICATION_ERROR(-20100, 'It is not allowed to update this table!');
    ELSIF INSERTING THEN

        SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, DateOfBirth) / 12) INTO age
        FROM UserAccount
        WHERE UserID = :new.UserID;

        SELECT Age INTO ageLimit
        FROM AgeGroup
        INNER JOIN Content ON Content.AGEGROUPID = AgeGroup.AGEGROUPID

        WHERE ContentID = :new.ContentID;
        IF age < ageLimit THEN
            RAISE_APPLICATION_ERROR(-20100, 'This user''s age is under the content age limitation!');
        END IF;

    ELSIF DELETING THEN

        SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, DateOfBirth) / 12) INTO age
        FROM UserAccount
        WHERE UserID = :old.UserID;

        IF age < 16 THEN
            RAISE_APPLICATION_ERROR(-20100, 'You cannot delete history of watched content of user under 16!');
        END IF;

    END IF;
END;

-- PROCEDURE1
CREATE OR REPLACE PROCEDURE PROCEDURE1
    (userEmail VARCHAR2, oldPassword VARCHAR2, newPassword VARCHAR2)
AS
    currentPassword VARCHAR2(64); countEmail NUMBER;
BEGIN
    SELECT COUNT(*) INTO countEmail
    FROM UserAccount
    WHERE Email = userEmail;

    IF countEmail = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The user registered under provided email was not found!');
    ELSE
        SELECT Password INTO currentPassword
        FROM UserAccount
        WHERE Email = userEmail;

        IF currentPassword = oldPassword THEN
            IF currentPassword = newPassword THEN
                DBMS_OUTPUT.PUT_LINE('New and old passwords cannot be the same!');
            ELSE
                UPDATE UserAccount
                SET Password = newPassword
                WHERE Email = userEmail;
                DBMS_OUTPUT.PUT_LINE('The password was changed successfully!');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('The old password is incorrect!');
        END IF;
    END IF;
END;

-- PROCEDURE2
CREATE OR REPLACE PROCEDURE PROCEDURE2
    (userEmail VARCHAR2, desiredGenre VARCHAR2)
AS
    rowNumber NUMBER;
    countGenre NUMBER;
    countEmail NUMBER;
    userEmailId NUMBER;
    counter NUMBER;
    addedCounter NUMBER;
    -- cursor will contain info about contents that have requested genre and translation into user's language
    CURSOR cur IS SELECT Content.ContentID, Content.NAME, Content.DESCRIPTION
            FROM Content
            INNER JOIN Audio ON Audio.ContentID = Content.ContentID
            INNER JOIN Language ON Language.LanguageID = Audio.LanguageID
            WHERE Language.LanguageID = (
                SELECT LanguageID
                FROM UserAccount
                WHERE Email = userEmail
            )
            UNION
            SELECT Content.ContentID, Content.Name, Content.Description
            FROM Content
            INNER JOIN Subtitles ON Subtitles.ContentID = Subtitles.ContentID
            INNER JOIN Language ON Language.LanguageID = Subtitles.LanguageID
            WHERE Language.LanguageID = (
                SELECT LanguageID
                FROM UserAccount
                WHERE Email = userEmail
            )
            INTERSECT
            SELECT Content.ContentID, Content.Name, Content.Description
            FROM Content
            INNER JOIN Genres ON Genres.ContentID = Content.ContentID
            INNER JOIN Genre ON Genre.GenreID = Genres.GenreID
            WHERE Genre.Name = desiredGenre
            INTERSECT
            SELECT Content.ContentID, Content.Name, Content.Description
            FROM Content
            INNER JOIN AgeGroup ON AgeGroup.AgeGroupID = Content.AgeGroupID
            WHERE Age <= TRUNC(MONTHS_BETWEEN(SYSDATE, (SELECT DateOfBirth FROM UserAccount WHERE Email = userEmail)) / 12);
        contentIdNumber NUMBER;
        contentName VARCHAR2(64);
        contentDescription VARCHAR2(1024);
BEGIN
    SELECT COUNT(*) INTO countEmail
    FROM UserAccount
    WHERE Email = userEmail;
    SELECT COUNT(*) INTO countGenre
    FROM Genre
    WHERE Name = desiredGenre;
    IF countEmail > 0 THEN
        IF countGenre > 0 THEN
            SELECT UserID INTO userEmailId
            FROM UserAccount
            WHERE Email = userEmail;
            rowNumber := 0;
            addedCounter := 0;
            OPEN cur;
            LOOP
                FETCH cur INTO contentIdNumber, contentName, contentDescription;
                EXIT WHEN cur%NOTFOUND;

                rowNumber := rowNumber + 1;
                DBMS_OUTPUT.PUT_LINE(rowNumber || '. Title: ' || contentName || '. Description: ' || contentDescription);

                SELECT COUNT(*) INTO counter
                FROM List
                WHERE ContentID = contentIdNumber AND UserID = userEmailId;

                IF counter = 0 THEN
                    INSERT INTO LIST (UserID, ContentID) VALUES (userEmailId, contentIdNumber);
                    addedCounter := addedCounter + 1;
                END IF;
            END LOOP;
            CLOSE cur;
            IF addedCounter > 0 THEN
                DBMS_OUTPUT.PUT_LINE('It was successfully added ' || addedCounter || ' TV show(s) or film(s) to you list!');
            ELSE
                DBMS_OUTPUT.PUT_LINE('All the found films or TV shows are already in your list!');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('The genre was not found!');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('The user was not found!');
    END IF;
END;

-- !!!TURN ON DBMS OUTPUT!!!

-- TESTING TRIGGER1

INSERT INTO EPISODE (EPISODEID, SERIESID, NAME, SEASON, EPISODEINSEASON, LENGTHMIN, RELEASEDATE) VALUES (71, 1, 'TEST NAME', 2, 1, 30, TO_DATE('2023-12-10', 'YYYY-MM-DD')); -- trying to add episode to completed TV show
INSERT INTO EPISODE (EPISODEID, SERIESID, NAME, SEASON, EPISODEINSEASON, LENGTHMIN, RELEASEDATE) VALUES (71, 3, 'TEST NAME', 1, 1, 30, TO_DATE('2023-12-10', 'YYYY-MM-DD')); -- trying to add episode to the wrong season
INSERT INTO EPISODE (EPISODEID, SERIESID, NAME, SEASON, EPISODEINSEASON, LENGTHMIN, RELEASEDATE) VALUES (71, 3, 'TEST NAME', 3, 1, 30, TO_DATE('2023-12-10', 'YYYY-MM-DD')); -- trying to add episode with wrong order number
INSERT INTO EPISODE (EPISODEID, SERIESID, NAME, SEASON, EPISODEINSEASON, LENGTHMIN, RELEASEDATE) VALUES (71, 3, 'TEST NAME', 4, 2, 30, TO_DATE('2023-12-10', 'YYYY-MM-DD')); -- trying to add episode with wrong order number
INSERT INTO EPISODE (EPISODEID, SERIESID, NAME, SEASON, EPISODEINSEASON, LENGTHMIN, RELEASEDATE) VALUES (71, 3, 'TEST NAME', 4, 1, 30, TO_DATE('2021-12-10', 'YYYY-MM-DD')); -- trying to add episode with earlier release date than the last added episode
INSERT INTO EPISODE (EPISODEID, SERIESID, NAME, SEASON, EPISODEINSEASON, LENGTHMIN, RELEASEDATE) VALUES (71, 3, 'TEST NAME', 4, 1, 30, TO_DATE('2024-03-29', 'YYYY-MM-DD')); -- successfully added
DELETE FROM EPISODE WHERE EPISODEID = 71;

-- TESTING TRIGGER2

SELECT USERID, TRUNC(MONTHS_BETWEEN(SYSDATE, DateOfBirth) / 12) FROM USERACCOUNT;
INSERT INTO WATCHED (USERID, CONTENTID) VALUES (4, 1); -- trying to insert connection between 16+ content and 15 years old user (fail)
INSERT INTO WATCHED (USERID, CONTENTID) VALUES (4, 4); -- trying to insert connection between 13+ content and 15 years old user (success)
DELETE FROM WATCHED WHERE USERID = 4; -- trying to delete watching history of 15 years old user (fail)
DELETE FROM WATCHED WHERE USERID = 1; -- trying to delete watching history of 23 years old user (success)
UPDATE WATCHED SET CONTENTID = 1 WHERE CONTENTID = 4 AND USERID = 4; -- trying to update the table

-- TESTING PROCEDURE1

CALL PROCEDURE1('dennissavchenko@gmail.co', '1#@ghf34@', 'testing'); -- email was not found
CALL PROCEDURE1('dennissavchenko@gmail.com', '1#@ghf34', 'testing'); -- incorrect password
CALL PROCEDURE1('dennissavchenko@gmail.com', '1#@ghf34@', '1#@ghf34@'); -- old and new passwords are the same
CALL PROCEDURE1('dennissavchenko@gmail.com', '1#@ghf34@', 'testing'); -- updated successfully
SELECT * FROM USERACCOUNT WHERE USERID = 1;

-- TESTING PROCEDURE2

SELECT * FROM LIST WHERE USERID = 1;
CALL PROCEDURE2('dennissavchenko@gmail.co', 'Thriller'); -- email was not found
CALL PROCEDURE2('dennissavchenko@gmail.com', 'testing'); -- genre was not found
CALL PROCEDURE2('dennissavchenko@gmail.com', 'Thriller'); -- all the found contents are already in the list
CALL PROCEDURE2('dennissavchenko@gmail.com', 'Romance'); -- successfully added some new contents to the list of the user
SELECT * FROM LIST WHERE USERID = 1;