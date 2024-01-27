-- PROCEDURE1
CREATE PROCEDURE PROCEDURE1
    @contentIdNumber INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM Content WHERE ContentID = @contentIdNumber) BEGIN -- checking if provided content exists in the database

        DECLARE @contentName VARCHAR(64), @contentDescription VARCHAR(1024), @warningTags VARCHAR(512), @ageLimit INT;
        SELECT @contentName = Name FROM Content WHERE ContentID = @contentIdNumber;
        SELECT @contentDescription = Description FROM Content WHERE ContentID = @contentIdNumber; -- getting description of the provided content
        SELECT @ageLimit = Age FROM AgeGroup INNER JOIN Content ON AgeGroup.AgeGroupID = Content.AgeGroupID WHERE ContentID = @contentIdNumber; -- getting an age limitation for the provided content

        PRINT ('Title: ' + CONVERT(VARCHAR(64), @contentName) + '.'); -- printing title of the content

        PRINT ('Description: ' + CONVERT(VARCHAR(1024), @contentDescription) + ''); -- printing description of the content

        IF EXISTS(SELECT 1 FROM WarningTag INNER JOIN ContentWarningTags ON WarningTag.TagID = ContentWarningTags.TagID WHERE ContentID = @contentIdNumber) BEGIN -- checking if the content has any warning tags

            DECLARE cur CURSOR FOR SELECT WarningTag.Name FROM WarningTag INNER JOIN ContentWarningTags on WarningTag.TagID = ContentWarningTags.TagID WHERE ContentID= @contentIdNumber; -- declaring a cursor that will contain all the warning tags of the content
            DECLARE @tagName VARCHAR(64);
            OPEN cur;

            FETCH NEXT FROM cur INTO @tagName;

            WHILE @@FETCH_STATUS = 0 BEGIN
                SET @warningTags = ISNULL(@warningTags, '') + ISNULL(@tagName, '') + ', '; -- appending @warningTags variable with next warning tag
                FETCH NEXT FROM cur INTO @tagName;
            END;

            CLOSE cur;
            DEALLOCATE cur;

            SET @warningTags = LEFT(@warningTags, LEN(@warningTags) - 1) + '.'; -- deleting the last comma and appending the variable with a period
            PRINT ('(' + CONVERT(VARCHAR, @ageLimit) + '+) ' + @warningTags); -- printing age limit and all the warning tags

        END;

        ELSE BEGIN
            PRINT ('(' + CONVERT(VARCHAR, @ageLimit) + '+)'); -- printing age limit in case content has no warning tags
        END;

        IF EXISTS(SELECT 1 FROM Series WHERE SeriesID = @contentIdNumber) BEGIN -- checking if the content is a series

            DECLARE @countSeasons INT, @countEpisodes INT, @countTime INT;

            SELECT @countSeasons = COUNT(*) from (SELECT Season, SeriesID FROM Episode WHERE SeriesID = @contentIdNumber GROUP BY Season, SeriesID) AS SUBQUERY; -- getting number of seasons of the series
            SELECT @countEpisodes = COUNT(*) from Episode where SeriesID = @contentIdNumber; -- getting total number of episodes of the series
            SELECT @countTime = SUM(LengthMin) FROM Episode WHERE SeriesID = @contentIdNumber; -- getting total length of all the episodes of the series

            IF (SELECT IsFinished FROM Series WHERE SeriesID = @contentIdNumber) = 1 BEGIN -- checking if the project is completed
                PRINT ('The project is completed!');
            END;
            ELSE BEGIN
                PRINT ('The project is not completed!');
            END;

            PRINT ('The TV Show has ' + CONVERT(VARCHAR, @countSeasons) + ' season(s), ' + CONVERT(VARCHAR, @countEpisodes) + ' episode(s). The full show lasts for ' + CONVERT(VARCHAR, @countTime / 60) + ' hour(s) and ' + CONVERT(VARCHAR, @countTime % 60) + ' minute(s).'); -- printing number of seasons, total number of episodes and time in hours and minutes

            DECLARE cur CURSOR FOR SELECT EpisodeInSeason, Name, LengthMin, Season, ReleaseDate FROM Episode WHERE SeriesID = @contentIdNumber; -- declaring cursor that will contain basic info about all the episodes of the series
            DECLARE @numberInSeason INT, @seriesName VARCHAR(64), @length INT, @season INT, @releaseD DATE;
            OPEN cur;

            FETCH NEXT FROM cur INTO @numberInSeason, @seriesName, @length, @season, @releaseD;

            WHILE @@FETCH_STATUS = 0 BEGIN
                IF @numberInSeason = 1 BEGIN -- checking if number of episode is one
                    PRINT (CONVERT(VARCHAR, @season) + ' SEASON (' + CONVERT(VARCHAR, YEAR(@releaseD)) + '):'); -- in this case before printing info about the episode it is printed number of season, episodes of which are going to be listed, and year of release
                END;
                PRINT (CONVERT(VARCHAR, @numberInSeason) + '. ' + @seriesName + ' (' + CONVERT(VARCHAR, @length) + 'm).'); -- printing info about episode
                FETCH NEXT FROM cur INTO @numberInSeason, @seriesName, @length, @season, @releaseD;
            END;

            CLOSE cur;
            DEALLOCATE cur;

        END;

        IF EXISTS(SELECT 1 FROM Film WHERE FilmID = @contentIdNumber) BEGIN -- checking if the content is a film

            DECLARE @countLength INT, @dateR DATE;

            SELECT @countLength = LengthMin FROM Film WHERE FilmID = @contentIdNumber; -- getting a length of the film
            SELECT @dateR = ReleaseDate FROM Film WHERE FilmID = @contentIdNumber; -- getting getting a release date of the film

            PRINT ('The film was released in ' + CONVERT(VARCHAR, YEAR(@dateR)) + '. It lasts for ' + CONVERT(VARCHAR, @countLength / 60) + ' hour(s) and ' + CONVERT(VARCHAR, @countLength % 60) + ' minute(s).') -- printing info about the release year and the length in hours and minutes

        END;
    END;

    ELSE BEGIN
        RAISERROR('Provided content was not found!', 16, 1); -- raising an exception if the provided content was not found
    END;
END;
go

-- PROCEDURE2
CREATE PROCEDURE PROCEDURE2
    @userEmail VARCHAR(64), @topNumber INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM UserAccount WHERE Email = @userEmail) BEGIN -- checking if email is present in the database
        DECLARE @userID INT;
        SELECT @userID = UserID FROM UserAccount WHERE Email = @userEmail; -- getting userID of the user with provided email
        IF @topNumber > 0 BEGIN -- checking if top number is positive

            DECLARE cur CURSOR FOR SELECT TOP (@topNumber) Content.ContentID, Content.Name, Content.Description -- the cursor will contain TOP (@topNumber) contents by likes
            FROM Content
            INNER JOIN Liked ON Content.ContentID = Liked.ContentID
            INNER JOIN UserAccount ON Liked.UserID = UserAccount.UserID
            INNER JOIN AgeGroup ON Content.AgeGroupID = AgeGroup.AgeGroupID
            WHERE Age <= (SELECT FLOOR(DATEDIFF(MONTH, DateOfBirth, GETDATE()) / 12) FROM UserAccount WHERE Email = @userEmail)
            GROUP BY Content.Name, Content.ContentID, Content.Description
            ORDER BY COUNT(*) DESC;

            DECLARE @contentIdNumber INT, @contentName VARCHAR(64), @contentDescription VARCHAR(1024);
            OPEN cur;

            FETCH NEXT FROM cur INTO @contentIdNumber, @contentName, @contentDescription;

            DECLARE @counterRow INT, @counterAdded INT;
            SET @counterRow = 0; -- will show the number of each found content
            SET @counterAdded = 0; -- will count how many contents were actually added to user's list

            WHILE @@FETCH_STATUS = 0 BEGIN

                SET @counterRow = @counterRow + 1;
                PRINT(CONVERT(VARCHAR, @counterRow) + '. Title: ' + @contentName + '. Description: ' + @contentDescription); -- printing content info
                IF NOT EXISTS(SELECT 1 FROM List WHERE UserID = @userID AND ContentID = @contentIdNumber) BEGIN -- checking if found content is not present in the user's list
                    SET @counterAdded = @counterAdded + 1;
                    INSERT INTO List (UserID, ContentID) VALUES (@userID, @contentIdNumber);
                END;
                FETCH NEXT FROM cur INTO @contentIdNumber, @contentName, @contentDescription;

            END;
            CLOSE cur;
            DEALLOCATE cur;
            IF @counterAdded = 0 BEGIN
                PRINT ('All the found contents are already in the list of the user (' + @userEmail + ').');
            END;
            ELSE BEGIN
                PRINT ('It was added ' + CONVERT(VARCHAR, @counterAdded) + ' new content(s) to the list of the user (' + @userEmail + ').');
            END;
        END;
        ELSE BEGIN
            RAISERROR('Top number has to be positive!', 16, 1);
        END;
    END;
    ELSE BEGIN
        RAISERROR('User under provided email was not found!', 16, 1);
    END;
END;
go

-- TRIGGER1
CREATE TRIGGER TRIGGER1
ON DEVICE
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        DECLARE cur CURSOR FOR SELECT IPAddress FROM inserted;
        DECLARE @address VARCHAR(64);
        OPEN cur;
        FETCH NEXT FROM cur INTO @address;
        WHILE @@FETCH_STATUS = 0 BEGIN
            IF (SELECT UserID FROM deleted WHERE IPAddress = @address) <> (SELECT UserID FROM inserted WHERE IPAddress = @address) BEGIN
                RAISERROR ('You cannot change user of a device!', 16, 1);
                ROLLBACK;
            END;
            FETCH NEXT FROM cur INTO @address;
        END;
        CLOSE cur;
        DEALLOCATE cur;
    END;
    ELSE IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        DECLARE cur CURSOR FOR SELECT UserID FROM inserted GROUP BY UserID;
        DECLARE @userID INT;
        OPEN cur;
        FETCH NEXT FROM cur INTO @userID;
        WHILE @@FETCH_STATUS = 0 BEGIN
            IF (SELECT COUNT(*) FROM Device WHERE UserID = @userID) > (SELECT NumberOfDevices FROM Subscription INNER JOIN UserAccount ON Subscription.SubscriptionID = UserAccount.SubscriptionID WHERE UserAccount.UserID = @userID) BEGIN
                RAISERROR ('You have exceeded number of devices!', 16, 1);
                ROLLBACK;
            END;
            FETCH NEXT FROM cur INTO @userID;
        END;
        CLOSE cur;
        DEALLOCATE cur;
    END;
    ELSE IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        DECLARE curD CURSOR FOR SELECT UserID FROM deleted GROUP BY UserID;
        DECLARE @userIDD INT;
        OPEN curD;
        FETCH NEXT FROM curD INTO @userIDD;
        WHILE @@FETCH_STATUS = 0 BEGIN
            IF (SELECT COUNT(*) FROM Device WHERE UserID = @userIDD) = 0 BEGIN
                RAISERROR ('User has to have at least one device connected!', 16, 1);
                ROLLBACK;
            END;
            FETCH NEXT FROM curD INTO @userIDD;
        END;
        CLOSE curD;
        DEALLOCATE curD;
    END;
END;
go

-- TRIGGER2
CREATE TRIGGER TRIGGER2
ON UserAccount
INSTEAD OF UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted) BEGIN
        DECLARE cur CURSOR FOR SELECT UserID FROM inserted;
        DECLARE @userIDU INT;
        OPEN cur;
        FETCH NEXT FROM cur INTO @userIDU;
        WHILE @@FETCH_STATUS = 0 BEGIN
            IF (SELECT Password FROM inserted WHERE UserID = @userIDU) = (SELECT Password FROM deleted WHERE UserID = @userIDU) BEGIN
                DECLARE @numI INT, @numD INT;
                SELECT @numI = NumberOfDevices FROM Subscription INNER JOIN inserted ON Subscription.SubscriptionID = inserted.SubscriptionID WHERE UserID = @userIDU;
                SELECT @numD = COUNT(*) FROM Device WHERE UserID = @userIDU;
                IF @numI < @numD BEGIN
                    DELETE TOP (@numD - @numI) FROM Device WHERE UserID = @userIDU;
                    PRINT 'You had ' + CONVERT(VARCHAR, @numD) + ' devices connected. Your new subscription allows you to have only ' + CONVERT(VARCHAR, @numI) + ' connected device(s). We had to delete ' + CONVERT(VARCHAR, (@numD - @numI)) + ' of them.';
                END;
                UPDATE UserAccount
                SET UserAccount.Name = inserted.Name, UserAccount.Surname = inserted.Surname, UserAccount.DateOfBirth = inserted.DateOfBirth, UserAccount.SubscriptionID = inserted.SubscriptionID, UserAccount.LanguageID = inserted.LanguageID
                FROM UserAccount INNER JOIN inserted ON UserAccount.UserID = inserted.userID
                WHERE UserAccount.UserID = @userIDU;
            END;
            ELSE RAISERROR ('Updating users'' passwords is not allowed; users whose passwords were edited have not been updated!', 16, 1);
            FETCH NEXT FROM cur INTO @userIDU;
        END;
        CLOSE cur;
        DEALLOCATE cur;
    END;
    ELSE IF EXISTS (SELECT 1 FROM deleted) BEGIN
        DECLARE cur CURSOR FOR SELECT UserID FROM deleted;
        DECLARE @userIDD INT;
        OPEN cur;
        FETCH NEXT FROM cur INTO @userIDD;
        WHILE @@FETCH_STATUS = 0 BEGIN
            DELETE FROM Watched WHERE UserID = @userIDD;
            DELETE FROM List WHERE UserID = @userIDD;
            DELETE FROM Liked WHERE UserID = @userIDD;
            DISABLE TRIGGER TRIGGER1 ON Device;
            DELETE FROM Device WHERE UserID = @userIDD;
            ENABLE TRIGGER TRIGGER1 ON Device;
            DELETE FROM UserAccount WHERE UserID = @userIDD;
            FETCH NEXT FROM cur INTO @userIDD;
        END;
        CLOSE cur;
        DEALLOCATE cur;
    END;
END;
go

-- TESTING PROCEDURE1

EXEC PROCEDURE1 10; -- content was not found
EXEC PROCEDURE1 3; -- printing series info
EXEC PROCEDURE1 5; -- printing film info

-- TESTING PROCEDURE2

EXEC PROCEDURE2 'dennissavchenko@gmail.co', 3; -- email was not found
EXEC PROCEDURE2 'dennissavchenko@gmail.com', -3; -- top number is not positive number
EXEC PROCEDURE2 'dennissavchenko@gmail.com', 3; -- prints three the most liked contents according to user's age and adds them to user's list

-- TESTING TRIGGER1

UPDATE Device SET UserID = 2 WHERE IPAddress = '172.16.0.1'; -- trying to change user of the IP address
INSERT INTO Device (IPAddress, UserID) VALUES ('123.54.3.32.2', 1); -- first user can have only one device connected, they cannot insert second one
DELETE FROM Device WHERE UserID = 1; -- trying to delete all devices of the user

-- TESTING TRIGGER2

UPDATE UserAccount SET Password = 'testing' WHERE UserID = 1; -- refuses to update password
UPDATE UserAccount SET SubscriptionID = 3 WHERE UserID = 1; -- setting subscriptionID to 3 (4 devices are allowed)
INSERT INTO Device (IPAddress, UserID) VALUES ('12.324.123.22', 1); -- adding another devise for the user
SELECT * FROM Device WHERE UserID = 1;
UPDATE UserAccount SET SubscriptionID = 1 WHERE UserID = 1; -- as long as the user has downgraded their subscription, some devices were deleted
SELECT * FROM Device WHERE UserID = 1;
DELETE FROM UserAccount WHERE UserID = 10; -- deleting a user
SELECT * FROM UserAccount;