-- tables
-- Table: Actor
CREATE TABLE Actor (
    ActorID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    Surname varchar2(64)  NOT NULL,
    CONSTRAINT Actor_pk PRIMARY KEY (ActorID)
) ;

-- Table: AgeGroup
CREATE TABLE AgeGroup (
    AgeGroupID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    Age integer  NOT NULL CHECK (Age > 0),
    CONSTRAINT AgeGroup_pk PRIMARY KEY (AgeGroupID)
) ;

-- Table: Audio
CREATE TABLE Audio (
    ContentID integer  NOT NULL,
    LanguageID integer  NOT NULL,
    CONSTRAINT Audio_pk PRIMARY KEY (LanguageID,ContentID)
) ;

-- Table: Cast
CREATE TABLE Cast (
    ContentID integer  NOT NULL,
    ActorID integer  NOT NULL,
    CONSTRAINT Cast_pk PRIMARY KEY (ContentID,ActorID)
) ;

-- Table: Content
CREATE TABLE Content (
    ContentID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    Description varchar2(1024)  NOT NULL,
    AgeGroupID integer  NOT NULL,
    CONSTRAINT Content_pk PRIMARY KEY (ContentID)
) ;

-- Table: ContentWarningTags
CREATE TABLE ContentWarningTags (
    ContentID integer  NOT NULL,
    TagID integer  NOT NULL,
    CONSTRAINT ContentWarningTags_pk PRIMARY KEY (TagID,ContentID)
) ;

-- Table: Device
CREATE TABLE Device (
    IPAddress varchar2(64)  NOT NULL,
    UserID integer  NOT NULL,
    CONSTRAINT Device_pk PRIMARY KEY (IPAddress)
) ;

-- Table: Episode
CREATE TABLE Episode (
    EpisodeID integer  NOT NULL,
    SeriesID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    Season integer  NOT NULL CHECK (Season > 0),
    EpisodeInSeason integer  NOT NULL CHECK (EpisodeInSeason > 0),
    LengthMin integer  NOT NULL CHECK (LengthMin > 0),
    ReleaseDate date  NOT NULL,
    CONSTRAINT Episode_pk PRIMARY KEY (EpisodeID)
) ;

-- Table: Film
CREATE TABLE Film (
    FilmID integer  NOT NULL,
    LengthMin integer  NOT NULL CHECK (LengthMin > 0),
    ReleaseDate date  NOT NULL,
    CONSTRAINT Film_pk PRIMARY KEY (FilmID)
) ;

-- Table: Genre
CREATE TABLE Genre (
    GenreID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    CONSTRAINT Genre_pk PRIMARY KEY (GenreID)
) ;

-- Table: Genres
CREATE TABLE Genres (
    ContentID integer  NOT NULL,
    GenreID integer  NOT NULL,
    CONSTRAINT Genres_pk PRIMARY KEY (GenreID,ContentID)
) ;

-- Table: Language
CREATE TABLE Language (
    LanguageID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    CONSTRAINT Language_pk PRIMARY KEY (LanguageID)
) ;

-- Table: Liked
CREATE TABLE Liked (
    UserID integer  NOT NULL,
    ContentID integer  NOT NULL,
    CONSTRAINT Liked_pk PRIMARY KEY (UserID,ContentID)
) ;

-- Table: List
CREATE TABLE List (
    UserID integer  NOT NULL,
    ContentID integer  NOT NULL,
    CONSTRAINT List_pk PRIMARY KEY (UserID,ContentID)
) ;

-- Table: Promotion
CREATE TABLE Promotion (
    PromotionID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    ContentID integer  NOT NULL,
    CONSTRAINT Promotion_pk PRIMARY KEY (PromotionID)
) ;

-- Table: Series
CREATE TABLE Series (
    SeriesID integer  NOT NULL,
    IsFinished integer  NOT NULL CHECK (IsFinished = 1 OR IsFinished = 0),
    CONSTRAINT Series_pk PRIMARY KEY (SeriesID)
) ;

-- Table: Subscription
CREATE TABLE Subscription (
    SubscriptionID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    NumberOfDevices integer  NOT NULL CHECK (NumberOfDevices > 0),
    CONSTRAINT Subscription_pk PRIMARY KEY (SubscriptionID)
) ;

-- Table: Subtitles
CREATE TABLE Subtitles (
    ContentID integer  NOT NULL,
    LanguageID integer  NOT NULL,
    CONSTRAINT Subtitles_pk PRIMARY KEY (LanguageID,ContentID)
) ;

-- Table: UserAccount
CREATE TABLE UserAccount (
    UserID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    Surname varchar2(64)  NOT NULL,
    DateOfBirth date  NOT NULL,
    Email varchar2(64)  NOT NULL,
    Password varchar2(64)  NOT NULL,
    LanguageID integer  NOT NULL,
    SubscriptionID integer  NOT NULL,
    CONSTRAINT UserAccount_pk PRIMARY KEY (UserID),
    CONSTRAINT Email_unique UNIQUE (Email)
) ;

-- Table: WarningTag
CREATE TABLE WarningTag (
    TagID integer  NOT NULL,
    Name varchar2(64)  NOT NULL,
    CONSTRAINT WarningTag_pk PRIMARY KEY (TagID)
) ;

-- Table: Watched
CREATE TABLE Watched (
    UserID integer  NOT NULL,
    ContentID integer  NOT NULL,
    CONSTRAINT Watched_pk PRIMARY KEY (UserID,ContentID)
) ;

-- foreign keys
-- Reference: Audio_Content (table: Audio)
ALTER TABLE Audio ADD CONSTRAINT Audio_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: Audio_Language (table: Audio)
ALTER TABLE Audio ADD CONSTRAINT Audio_Language
    FOREIGN KEY (LanguageID)
    REFERENCES Language (LanguageID);

-- Reference: Cast_Actor (table: Cast)
ALTER TABLE Cast ADD CONSTRAINT Cast_Actor
    FOREIGN KEY (ActorID)
    REFERENCES Actor (ActorID);

-- Reference: Cast_Content (table: Cast)
ALTER TABLE Cast ADD CONSTRAINT Cast_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: ContentWarningTags_Content (table: ContentWarningTags)
ALTER TABLE ContentWarningTags ADD CONSTRAINT ContentWarningTags_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: ContentWarningTags_WarningTag (table: ContentWarningTags)
ALTER TABLE ContentWarningTags ADD CONSTRAINT ContentWarningTags_WarningTag
    FOREIGN KEY (TagID)
    REFERENCES WarningTag (TagID);

-- Reference: Content_AgeGroup (table: Content)
ALTER TABLE Content ADD CONSTRAINT Content_AgeGroup
    FOREIGN KEY (AgeGroupID)
    REFERENCES AgeGroup (AgeGroupID);

-- Reference: Device_UserAccount (table: Device)
ALTER TABLE Device ADD CONSTRAINT Device_UserAccount
    FOREIGN KEY (UserID)
    REFERENCES UserAccount (UserID);

-- Reference: Episode_Series (table: Episode)
ALTER TABLE Episode ADD CONSTRAINT Episode_Series
    FOREIGN KEY (SeriesID)
    REFERENCES Series (SeriesID);

-- Reference: Film_Content (table: Film)
ALTER TABLE Film ADD CONSTRAINT Film_Content
    FOREIGN KEY (FilmID)
    REFERENCES Content (ContentID);

-- Reference: Genres_Content (table: Genres)
ALTER TABLE Genres ADD CONSTRAINT Genres_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: Genres_Genre (table: Genres)
ALTER TABLE Genres ADD CONSTRAINT Genres_Genre
    FOREIGN KEY (GenreID)
    REFERENCES Genre (GenreID);

-- Reference: Liked_Content (table: Liked)
ALTER TABLE Liked ADD CONSTRAINT Liked_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: Liked_User (table: Liked)
ALTER TABLE Liked ADD CONSTRAINT Liked_User
    FOREIGN KEY (UserID)
    REFERENCES UserAccount (UserID);

-- Reference: List_Content (table: List)
ALTER TABLE List ADD CONSTRAINT List_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: List_User (table: List)
ALTER TABLE List ADD CONSTRAINT List_User
    FOREIGN KEY (UserID)
    REFERENCES UserAccount (UserID);

-- Reference: Promotion_Content (table: Promotion)
ALTER TABLE Promotion ADD CONSTRAINT Promotion_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: Series_Content (table: Series)
ALTER TABLE Series ADD CONSTRAINT Series_Content
    FOREIGN KEY (SeriesID)
    REFERENCES Content (ContentID);

-- Reference: Subtitles_Content (table: Subtitles)
ALTER TABLE Subtitles ADD CONSTRAINT Subtitles_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: Subtitles_Language (table: Subtitles)
ALTER TABLE Subtitles ADD CONSTRAINT Subtitles_Language
    FOREIGN KEY (LanguageID)
    REFERENCES Language (LanguageID);

-- Reference: UserAccount_Language (table: UserAccount)
ALTER TABLE UserAccount ADD CONSTRAINT UserAccount_Language
    FOREIGN KEY (LanguageID)
    REFERENCES Language (LanguageID);

-- Reference: User_Subscription (table: UserAccount)
ALTER TABLE UserAccount ADD CONSTRAINT User_Subscription
    FOREIGN KEY (SubscriptionID)
    REFERENCES Subscription (SubscriptionID);

-- Reference: Watched_Content (table: Watched)
ALTER TABLE Watched ADD CONSTRAINT Watched_Content
    FOREIGN KEY (ContentID)
    REFERENCES Content (ContentID);

-- Reference: Watched_UserAccount (table: Watched)
ALTER TABLE Watched ADD CONSTRAINT Watched_UserAccount
    FOREIGN KEY (UserID)
    REFERENCES UserAccount (UserID);

-- End of file.

-- Filling the database.
-- Actor

-- Ratched
INSERT INTO Actor (ActorID, Name, Surname) VALUES (1, 'Sarah', 'Paulson');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (2, 'Finn', 'Wittrock');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (3, 'Cynthia', 'Nixon');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (4, 'Judy', 'Davis');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (5, 'Sharon', 'Stone');

-- Sex Education
INSERT INTO Actor (ActorID, Name, Surname) VALUES (6, 'Asa', 'Butterfield');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (7, 'Gillian', 'Anderson');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (8, 'Emma', 'Mackey');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (9, 'Ncuti', 'Gatwa');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (10, 'Connor', 'Swindells');

-- Snowpiercer
INSERT INTO Actor (ActorID, Name, Surname) VALUES (11, 'Jennifer', 'Connelly');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (12, 'Daveed', 'Diggs');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (13, 'Mickey', 'Sumner');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (14, 'Alison', 'Wright');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (15, 'Lena', 'Hall');

-- Mean Girls
INSERT INTO Actor (ActorID, Name, Surname) VALUES (16, 'Lindsay', 'Lohan');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (17, 'Rachel', 'McAdams');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (18, 'Amanda', 'Seyfried');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (19, 'Lacey', 'Chabert');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (20, 'Tina', 'Fey');

-- The Craft
INSERT INTO Actor (ActorID, Name, Surname) VALUES (21, 'Fairuza', 'Balk');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (22, 'Robin', 'Tunney');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (23, 'Neve', 'Campbell');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (24, 'Rachel', 'True');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (25, 'Skeet', 'Ulrich');

-- Senior Year
INSERT INTO Actor (ActorID, Name, Surname) VALUES (26, 'Karan', 'Johar');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (27, 'Manisha', 'Koirala');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (28, 'Ranveer', 'Singh');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (29, 'Boman', 'Irani');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (30, 'Raveena', 'Tandon');

-- Clueless
INSERT INTO Actor (ActorID, Name, Surname) VALUES (31, 'Alicia', 'Silverstone');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (32, 'Stacey', 'Dash');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (33, 'Brittany', 'Murphy');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (34, 'Paul', 'Rudd');
INSERT INTO Actor (ActorID, Name, Surname) VALUES (35, 'Donald', 'Faison');

-- AgeGroup

INSERT INTO AgeGroup (AgeGroupID, Name, Age) VALUES (1, 'Kids', 7);
INSERT INTO AgeGroup (AgeGroupID, Name, Age) VALUES (2, 'Teens', 13);
INSERT INTO AgeGroup (AgeGroupID, Name, Age) VALUES (3, 'Late Teens', 16);
INSERT INTO AgeGroup (AgeGroupID, Name, Age) VALUES (4, 'Adults', 18);

-- Genre

INSERT INTO Genre (GenreID, Name) VALUES (1, 'Comedy');
INSERT INTO Genre (GenreID, Name) VALUES (2, 'Romantic Comedy');
INSERT INTO Genre (GenreID, Name) VALUES (3, 'Drama');
INSERT INTO Genre (GenreID, Name) VALUES (4, 'Romance');
INSERT INTO Genre (GenreID, Name) VALUES (5, 'Teen');
INSERT INTO Genre (GenreID, Name) VALUES (6, 'Horror');
INSERT INTO Genre (GenreID, Name) VALUES (7, 'Mystery');
INSERT INTO Genre (GenreID, Name) VALUES (8, 'Adventure');
INSERT INTO Genre (GenreID, Name) VALUES (9, 'Thriller');
INSERT INTO Genre (GenreID, Name) VALUES (10, 'Sci-Fi');

-- Language

INSERT INTO Language (LanguageID, Name) VALUES (1, 'English');
INSERT INTO Language (LanguageID, Name) VALUES (2, 'Spanish');
INSERT INTO Language (LanguageID, Name) VALUES (3, 'French');
INSERT INTO Language (LanguageID, Name) VALUES (4, 'German');
INSERT INTO Language (LanguageID, Name) VALUES (5, 'Chinese');
INSERT INTO Language (LanguageID, Name) VALUES (6, 'Japanese');
INSERT INTO Language (LanguageID, Name) VALUES (7, 'Korean');
INSERT INTO Language (LanguageID, Name) VALUES (8, 'Ukrainian');
INSERT INTO Language (LanguageID, Name) VALUES (9, 'Italian');
INSERT INTO Language (LanguageID, Name) VALUES (10, 'Polish');

-- WarningTag

INSERT INTO WarningTag (TagID, Name) VALUES (1, 'Sex');
INSERT INTO WarningTag (TagID, Name) VALUES (2, 'Language');
INSERT INTO WarningTag (TagID, Name) VALUES (3, 'Violence');
INSERT INTO WarningTag (TagID, Name) VALUES (4, 'Suicide');
INSERT INTO WarningTag (TagID, Name) VALUES (5, 'Nudity');

-- Subscription

INSERT INTO Subscription (SubscriptionID, Name, NumberOfDevices) VALUES (1, 'Basic', 1);
INSERT INTO Subscription (SubscriptionID, Name, NumberOfDevices) VALUES (2, 'Standard', 2);
INSERT INTO Subscription (SubscriptionID, Name, NumberOfDevices) VALUES (3, 'Premium', 4);

-- Content

-- Ratched
INSERT INTO Content (ContentID, Name, Description, AgeGroupID)
VALUES (1, 'Ratched', 'In 1947, Mildred Ratched begins working as a nurse at a leading psychiatric hospital. But beneath her stylish exterior lurks a growing darkness.', 3);
-- Sex Education
INSERT INTO Content (ContentID, Name, Description, AgeGroupID)
VALUES (2, 'Sex Education', 'A teenage boy with a sex therapist mother teams up with a high school classmate to set up an underground sex therapy clinic at school.', 3);
-- Snowpiercer
INSERT INTO Content (ContentID, Name, Description, AgeGroupID)
VALUES (3, 'Snowpiercer', 'Seven years after the world has become a frozen wasteland, the remnants of humanity inhabit a perpetually-moving train that circles the globe, where class warfare, social injustice and the politics of survival play out.', 3);
-- Mean Girls
INSERT INTO Content (ContentID, Name, Description, AgeGroupID)
VALUES (4, 'Mean Girls', 'Cady Heron is a hit with The Plastics, the A-list girl clique at her new school, until she makes the mistake of falling for Aaron Samuels, the ex-boyfriend of alpha Plastic Regina George.', 2);
-- The Craft
INSERT INTO Content (ContentID, Name, Description, AgeGroupID)
VALUES (5, 'The Craft', 'A newcomer to a Catholic prep high school falls in with a trio of outcast teenage girls who practice witchcraft, and they all soon conjure up various spells and curses against those who anger them.', 3);
-- Senior Year
INSERT INTO Content (ContentID, Name, Description, AgeGroupID)
VALUES (6, 'Senior Year', 'A cheerleading stunt gone wrong landed her in a 20-year coma. Now she''s 37, newly awake and ready to live out her high school dream: becoming prom queen.', 3);
-- Clueless
INSERT INTO Content (ContentID, Name, Description, AgeGroupID)
VALUES (7, 'Clueless', 'Shallow, rich and socially successful Cher is at the top of her Beverly Hills high school''s pecking scale. Seeing herself as a matchmaker, Cher first coaxes two teachers into dating each other.', 2);

-- UserAccount

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (1, 'Dennis', 'Savchenko', TO_DATE('2000-01-15', 'YYYY-MM-DD'), 'dennissavchenko@gmail.com', '1#@ghf34@', 8, 1);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (2, 'Rose', 'Smith', TO_DATE('2005-08-22', 'YYYY-MM-DD'), 'rosesmith@gmail.com', '#ed$%%2ws', 1, 3);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (3, 'John', 'Doe', TO_DATE('2010-04-05', 'YYYY-MM-DD'), 'johndoe@gmail.com', 'P@ssw0rd', 3, 2);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (4, 'Emily', 'Johnson', TO_DATE('2008-11-18', 'YYYY-MM-DD'), 'emilyjohnson@gmail.com', 'Qwerty123', 5, 1);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (5, 'Michael', 'Brown', TO_DATE('1995-06-30', 'YYYY-MM-DD'), 'michaelbrown@gmail.com', 'SecurePwd456', 7, 3);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (6, 'Sophia', 'Lee', TO_DATE('2007-09-12', 'YYYY-MM-DD'), 'sophialee@gmail.com', 'Pa$$word789', 10, 2);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (7, 'David', 'Garcia', TO_DATE('2011-02-25', 'YYYY-MM-DD'), 'davidgarcia@gmail.com', 'Secret123', 2, 1);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (8, 'Olivia', 'Martinez', TO_DATE('2002-07-08', 'YYYY-MM-DD'), 'oliviamartinez@gmail.com', 'P@ssw0rd456', 4, 3);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (9, 'William', 'Taylor', TO_DATE('1989-12-20', 'YYYY-MM-DD'), 'williamtaylor@gmail.com', 'MyP@ss123', 6, 2);

INSERT INTO UserAccount (UserID, Name, Surname, DateOfBirth, Email, Password, LanguageID, SubscriptionID)
VALUES (10, 'Emma', 'Anderson', TO_DATE('1999-03-10', 'YYYY-MM-DD'), 'emmaanderson@gmail.com', 'SecurePwd789', 8, 1);

-- Series

INSERT INTO Series (SeriesID, IsFinished) VALUES (1, 1);
INSERT INTO Series (SeriesID, IsFinished) VALUES (2, 1);
INSERT INTO Series (SeriesID, IsFinished) VALUES (3, 0);

-- Film

INSERT INTO Film (FilmID, LengthMin, ReleaseDate) VALUES (4, 97, TO_DATE('2004-08-06', 'YYYY-MM-DD'));
INSERT INTO Film (FilmID, LengthMin, ReleaseDate) VALUES (5, 101, TO_DATE('1996-07-05', 'YYYY-MM-DD'));
INSERT INTO Film (FilmID, LengthMin, ReleaseDate) VALUES (6, 113, TO_DATE('2022-05-13', 'YYYY-MM-DD'));
INSERT INTO Film (FilmID, LengthMin, ReleaseDate) VALUES (7, 97, TO_DATE('1995-12-08', 'YYYY-MM-DD'));

-- Episode

--Ratched
-- 1 Season
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (1, 1, 'Pilot', 1, 1, 56, TO_DATE('2020-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (2, 1, 'Ice Pick', 1, 2, 50, TO_DATE('2020-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (3, 1, 'Angel of Mercy', 1, 3, 50, TO_DATE('2020-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (4, 1, 'Angel of Mercy: Part Two', 1, 4, 53, TO_DATE('2020-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (5, 1, 'The Dance', 1, 5, 62, TO_DATE('2020-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (6, 1, 'Got No Strings', 1, 6, 45, TO_DATE('2020-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (7, 1, 'The Bucket List', 1, 7, 58, TO_DATE('2020-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (8, 1, 'Mildred and Edmund', 1, 8, 59, TO_DATE('2020-09-18', 'YYYY-MM-DD'));

-- Sex Education
-- 1 Season
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (9, 2, 'Episode 1', 1, 1, 52, TO_DATE('2019-01-12', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (10, 2, 'Episode 2', 1, 2, 50, TO_DATE('2019-01-12', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (11, 2, 'Episode 3', 1, 3, 51, TO_DATE('2019-01-12', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (12, 2, 'Episode 4', 1, 4, 47, TO_DATE('2019-01-12', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (13, 2, 'Episode 5', 1, 5, 47, TO_DATE('2019-01-12', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (14, 2, 'Episode 6', 1, 6, 50, TO_DATE('2019-01-12', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (15, 2, 'Episode 7', 1, 7, 52, TO_DATE('2019-01-12', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (16, 2, 'Episode 8', 1, 8, 53, TO_DATE('2019-01-12', 'YYYY-MM-DD'));

-- 2 Season
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (17, 2, 'Episode 1', 2, 1, 51, TO_DATE('2020-01-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (18, 2, 'Episode 2', 2, 2, 51, TO_DATE('2020-01-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (19, 2, 'Episode 3', 2, 3, 49, TO_DATE('2020-01-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (20, 2, 'Episode 4', 2, 4, 51, TO_DATE('2020-01-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (21, 2, 'Episode 5', 2, 5, 53, TO_DATE('2020-01-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (22, 2, 'Episode 6', 2, 6, 55, TO_DATE('2020-01-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (23, 2, 'Episode 7', 2, 7, 50, TO_DATE('2020-01-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (24, 2, 'Episode 8', 2, 8, 59, TO_DATE('2020-01-18', 'YYYY-MM-DD'));

-- 3 Season
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (25, 2, 'Episode 1', 3, 1, 54, TO_DATE('2021-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (26, 2, 'Episode 2', 3, 2, 61, TO_DATE('2021-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (27, 2, 'Episode 3', 3, 3, 53, TO_DATE('2021-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (28, 2, 'Episode 4', 3, 4, 54, TO_DATE('2021-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (29, 2, 'Episode 5', 3, 5, 54, TO_DATE('2021-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (30, 2, 'Episode 6', 3, 6, 59, TO_DATE('2021-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (31, 2, 'Episode 7', 3, 7, 58, TO_DATE('2021-09-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (32, 2, 'Episode 8', 3, 8, 60, TO_DATE('2021-09-18', 'YYYY-MM-DD'));

-- 4 Season
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (33, 2, 'Episode 1', 4, 1, 55, TO_DATE('2023-09-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (34, 2, 'Episode 2', 4, 2, 51, TO_DATE('2023-09-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (35, 2, 'Episode 3', 4, 3, 55, TO_DATE('2023-09-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (36, 2, 'Episode 4', 4, 4, 56, TO_DATE('2023-09-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (37, 2, 'Episode 5', 4, 5, 55, TO_DATE('2023-09-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (38, 2, 'Episode 6', 4, 6, 66, TO_DATE('2023-09-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (39, 2, 'Episode 7', 4, 7, 60, TO_DATE('2023-09-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (40, 2, 'Episode 8', 4, 8, 85, TO_DATE('2023-09-22', 'YYYY-MM-DD'));

-- Snowpiercer
-- 1 Season
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (41, 3, 'First, the Weather Chan', 1, 1, 52, TO_DATE('2020-05-18', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (42, 3, 'Prepare to Brace', 1, 2, 46, TO_DATE('2020-05-25', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (43, 3, 'Access Is Power', 1, 3, 46, TO_DATE('2020-06-01', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (44, 3, 'Without Their Maker', 1, 4, 46, TO_DATE('2020-06-08', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (45, 3, 'Justice Never Boarded', 1, 5, 47, TO_DATE('2020-06-15', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (46, 3, 'Trouble Comes Sideways', 1, 6, 46, TO_DATE('2020-06-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (47, 3, 'The Universe Is Indifferent', 1, 7, 47, TO_DATE('2020-06-29', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (48, 3, 'These Are His Revolutions', 1, 8, 48, TO_DATE('2020-07-06', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (49, 3, 'EThe Train Demanded Blood', 1, 9, 44, TO_DATE('2020-07-13', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (50, 3, '994 Cars Long', 1, 10, 45, TO_DATE('2020-07-13', 'YYYY-MM-DD'));

-- 2 Season
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (51, 3, 'The Time of Two Engines', 2, 1, 47, TO_DATE('2021-01-21', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (52, 3, 'Smolder to Life', 2, 2, 48, TO_DATE('2021-02-02', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (53, 3, 'A Great Odyssey', 2, 3, 45, TO_DATE('2021-02-09', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (54, 3, 'A Single Trade', 2, 4, 47, TO_DATE('2021-02-16', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (55, 3, 'Keep Hope Alive', 2, 5, 47, TO_DATE('2021-02-23', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (56, 3, 'Many Miles from Snowpiercer', 2, 6, 46, TO_DATE('2021-03-02', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (57, 3, 'Our Answer for Everything', 2, 7, 47, TO_DATE('2021-03-09', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (58, 3, 'The Eternal Engineer', 2, 8, 48, TO_DATE('2021-03-16', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (59, 3, 'The Show Must Go On', 2, 9, 47, TO_DATE('2021-03-30', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (60, 3, 'Into the White', 2, 10, 47, TO_DATE('2021-03-30', 'YYYY-MM-DD'));

-- 3 Season
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (61, 3, 'The Tortoise and the Hare', 3, 1, 47, TO_DATE('2022-01-25', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (62, 3, 'The Last to Go', 3, 2, 47, TO_DATE('2022-02-01', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (63, 3, 'The First Blow', 3, 3, 46, TO_DATE('2022-02-08', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (64, 3, 'Bound by One Track', 3, 4, 47, TO_DATE('2022-02-15', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (65, 3, 'A New Life', 3, 5, 44, TO_DATE('2022-02-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (66, 3, 'Born to Bleed', 3, 6, 47, TO_DATE('2022-03-01', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (67, 3, 'Ouroboros', 3, 7, 45, TO_DATE('2022-03-08', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (68, 3, 'Setting Itself Right', 3, 8, 47, TO_DATE('2022-03-15', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (69, 3, 'A Beacon for Us All', 2, 9, 47, TO_DATE('2022-03-22', 'YYYY-MM-DD'));
INSERT INTO Episode (EpisodeID, SeriesID, Name, Season, EpisodeInSeason, LengthMin, ReleaseDate) VALUES (70, 3, 'The Original Sinners', 2, 10, 49, TO_DATE('2022-03-29', 'YYYY-MM-DD'));

-- ContentWarningTags

-- Ratched
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (1, 1);
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (1, 2);
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (1, 3);

-- Sex Education
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (2, 1);
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (2, 2);
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (2, 5);

-- Snowpiercer
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (3, 1);
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (3, 3);
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (3, 4);

-- The Craft
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (5, 3);

-- Senior Year
INSERT INTO ContentWarningTags (ContentID, TagID) VALUES (6, 2);

-- Cast

-- Ratched
INSERT INTO Cast (ContentID, ActorID) VALUES (1, 1);
INSERT INTO Cast (ContentID, ActorID) VALUES (1, 2);
INSERT INTO Cast (ContentID, ActorID) VALUES (1, 3);
INSERT INTO Cast (ContentID, ActorID) VALUES (1, 4);
INSERT INTO Cast (ContentID, ActorID) VALUES (1, 5);

-- Sex Education
INSERT INTO Cast (ContentID, ActorID) VALUES (2, 6);
INSERT INTO Cast (ContentID, ActorID) VALUES (2, 7);
INSERT INTO Cast (ContentID, ActorID) VALUES (2, 8);
INSERT INTO Cast (ContentID, ActorID) VALUES (2, 9);
INSERT INTO Cast (ContentID, ActorID) VALUES (2, 10);

-- Snowpiercer
INSERT INTO Cast (ContentID, ActorID) VALUES (3, 11);
INSERT INTO Cast (ContentID, ActorID) VALUES (3, 12);
INSERT INTO Cast (ContentID, ActorID) VALUES (3, 13);
INSERT INTO Cast (ContentID, ActorID) VALUES (3, 14);
INSERT INTO Cast (ContentID, ActorID) VALUES (3, 15);

-- Mean Girls
INSERT INTO Cast (ContentID, ActorID) VALUES (4, 16);
INSERT INTO Cast (ContentID, ActorID) VALUES (4, 17);
INSERT INTO Cast (ContentID, ActorID) VALUES (4, 18);
INSERT INTO Cast (ContentID, ActorID) VALUES (4, 19);
INSERT INTO Cast (ContentID, ActorID) VALUES (4, 20);

-- The Craft
INSERT INTO Cast (ContentID, ActorID) VALUES (5, 21);
INSERT INTO Cast (ContentID, ActorID) VALUES (5, 22);
INSERT INTO Cast (ContentID, ActorID) VALUES (5, 23);
INSERT INTO Cast (ContentID, ActorID) VALUES (5, 24);
INSERT INTO Cast (ContentID, ActorID) VALUES (5, 25);

-- Senior Year
INSERT INTO Cast (ContentID, ActorID) VALUES (6, 26);
INSERT INTO Cast (ContentID, ActorID) VALUES (6, 27);
INSERT INTO Cast (ContentID, ActorID) VALUES (6, 28);
INSERT INTO Cast (ContentID, ActorID) VALUES (6, 29);
INSERT INTO Cast (ContentID, ActorID) VALUES (6, 30);

-- Clueless
INSERT INTO Cast (ContentID, ActorID) VALUES (7, 31);
INSERT INTO Cast (ContentID, ActorID) VALUES (7, 32);
INSERT INTO Cast (ContentID, ActorID) VALUES (7, 33);
INSERT INTO Cast (ContentID, ActorID) VALUES (7, 34);
INSERT INTO Cast (ContentID, ActorID) VALUES (7, 35);

-- Promotion

-- Ratched
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (1, 'Season 1: Episode 1 Director''s cut', 1);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (2, 'Season 1 Trailer: Ratched', 1);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (3, 'Season 1 Trailer 2: Ratched', 1);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (4, 'Season 1: Take Care', 1);

-- Sex Education
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (5, 'Season 1 Recap: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (6, 'Season 1 Trailer: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (7, 'Season 2 Recap: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (8, 'Season 2 Trailer: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (9, 'Season 3 Trailer: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (10, 'Season 3 Trailer 2: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (11, 'Season 2 Recap: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (12, 'Season 2 Trailer: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (13, 'Season 3 Trailer: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (14, 'Season 3 Trailer 2: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (15, 'Sex Education: Season 3: Jean Teaser', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (16, 'Sex Education: Season 3: Otis & Maeve Teaser', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (17, 'Season 3 Teaser: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (18, 'Season 4 Trailer: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (19, 'Season 4 Teaser 1: Sex Education', 2);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (20, 'Season 4 Teaser 2: Sex Education', 2);

-- Snowpiercer
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (21, 'Season 1 Trailer: Snowpiercer', 3);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (22, 'Season 1 Recap: Snowpiercer', 3);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (23, 'Season 2 Trailer: Snowpiercer', 3);

-- Senior Year
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (24, 'Teaser: Senior Year', 6);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (25, 'Teaser #2: Senior Year', 6);
INSERT INTO Promotion (PromotionID, Name, ContentID) VALUES (26, 'Trailer: Senior Year', 6);

-- Genres

--Ratched
INSERT INTO Genres (ContentID, GenreID) VALUES (1, 3);
INSERT INTO Genres (ContentID, GenreID) VALUES (1, 6);
INSERT INTO Genres (ContentID, GenreID) VALUES (1, 7);
INSERT INTO Genres (ContentID, GenreID) VALUES (1, 9);

-- Sex Education
INSERT INTO Genres (ContentID, GenreID) VALUES (2, 1);
INSERT INTO Genres (ContentID, GenreID) VALUES (2, 3);
INSERT INTO Genres (ContentID, GenreID) VALUES (2, 4);
INSERT INTO Genres (ContentID, GenreID) VALUES (2, 5);
INSERT INTO Genres (ContentID, GenreID) VALUES (2, 8);

-- Snowpiercer
INSERT INTO Genres (ContentID, GenreID) VALUES (3, 3);
INSERT INTO Genres (ContentID, GenreID) VALUES (3, 7);
INSERT INTO Genres (ContentID, GenreID) VALUES (3, 8);
INSERT INTO Genres (ContentID, GenreID) VALUES (3, 10);

-- Mean Girls
INSERT INTO Genres (ContentID, GenreID) VALUES (4, 1);
INSERT INTO Genres (ContentID, GenreID) VALUES (4, 2);
INSERT INTO Genres (ContentID, GenreID) VALUES (4, 3);
INSERT INTO Genres (ContentID, GenreID) VALUES (4, 4);
INSERT INTO Genres (ContentID, GenreID) VALUES (4, 5);

-- The Craft
INSERT INTO Genres (ContentID, GenreID) VALUES (5, 3);
INSERT INTO Genres (ContentID, GenreID) VALUES (5, 5);
INSERT INTO Genres (ContentID, GenreID) VALUES (5, 6);
INSERT INTO Genres (ContentID, GenreID) VALUES (5, 7);
INSERT INTO Genres (ContentID, GenreID) VALUES (5, 8);
INSERT INTO Genres (ContentID, GenreID) VALUES (5, 9);

-- Senior Year
INSERT INTO Genres (ContentID, GenreID) VALUES (6, 1);
INSERT INTO Genres (ContentID, GenreID) VALUES (6, 2);
INSERT INTO Genres (ContentID, GenreID) VALUES (6, 3);
INSERT INTO Genres (ContentID, GenreID) VALUES (6, 4);
INSERT INTO Genres (ContentID, GenreID) VALUES (6, 5);

-- Clueless
INSERT INTO Genres (ContentID, GenreID) VALUES (7, 1);
INSERT INTO Genres (ContentID, GenreID) VALUES (7, 2);
INSERT INTO Genres (ContentID, GenreID) VALUES (7, 3);
INSERT INTO Genres (ContentID, GenreID) VALUES (7, 4);
INSERT INTO Genres (ContentID, GenreID) VALUES (7, 5);

-- Audio

--Ratched
INSERT INTO Audio (ContentID, LanguageID) VALUES (1, 1);
INSERT INTO Audio (ContentID, LanguageID) VALUES (1, 3);
INSERT INTO Audio (ContentID, LanguageID) VALUES (1, 4);
INSERT INTO Audio (ContentID, LanguageID) VALUES (1, 5);
INSERT INTO Audio (ContentID, LanguageID) VALUES (1, 6);
INSERT INTO Audio (ContentID, LanguageID) VALUES (1, 10);

-- Sex Education
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 1);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 2);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 3);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 4);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 5);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 6);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 7);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 8);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 9);
INSERT INTO Audio (ContentID, LanguageID) VALUES (2, 10);

-- Snowpiercer
INSERT INTO Audio (ContentID, LanguageID) VALUES (3, 1);
INSERT INTO Audio (ContentID, LanguageID) VALUES (3, 3);
INSERT INTO Audio (ContentID, LanguageID) VALUES (3, 4);
INSERT INTO Audio (ContentID, LanguageID) VALUES (3, 5);
INSERT INTO Audio (ContentID, LanguageID) VALUES (3, 6);
INSERT INTO Audio (ContentID, LanguageID) VALUES (3, 7);
INSERT INTO Audio (ContentID, LanguageID) VALUES (3, 8);
INSERT INTO Audio (ContentID, LanguageID) VALUES (3, 10);

-- Mean Girls
INSERT INTO Audio (ContentID, LanguageID) VALUES (4, 1);
INSERT INTO Audio (ContentID, LanguageID) VALUES (4, 2);
INSERT INTO Audio (ContentID, LanguageID) VALUES (4, 5);
INSERT INTO Audio (ContentID, LanguageID) VALUES (4, 8);

-- The Craft
INSERT INTO Audio (ContentID, LanguageID) VALUES (5, 1);
INSERT INTO Audio (ContentID, LanguageID) VALUES (5, 3);
INSERT INTO Audio (ContentID, LanguageID) VALUES (5, 4);

-- Senior Year
INSERT INTO Audio (ContentID, LanguageID) VALUES (6, 1);
INSERT INTO Audio (ContentID, LanguageID) VALUES (6, 2);
INSERT INTO Audio (ContentID, LanguageID) VALUES (6, 4);
INSERT INTO Audio (ContentID, LanguageID) VALUES (6, 5);
INSERT INTO Audio (ContentID, LanguageID) VALUES (6, 6);
INSERT INTO Audio (ContentID, LanguageID) VALUES (6, 7);
INSERT INTO Audio (ContentID, LanguageID) VALUES (6, 8);
INSERT INTO Audio (ContentID, LanguageID) VALUES (6, 9);

-- Clueless
INSERT INTO Audio (ContentID, LanguageID) VALUES (7, 1);
INSERT INTO Audio (ContentID, LanguageID) VALUES (7, 2);
INSERT INTO Audio (ContentID, LanguageID) VALUES (7, 3);
INSERT INTO Audio (ContentID, LanguageID) VALUES (7, 8);
INSERT INTO Audio (ContentID, LanguageID) VALUES (7, 10);

-- Subtitles

--Ratched
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 1);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 2);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 3);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 4);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 5);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 6);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 7);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 8);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (1, 10);


-- Sex Education
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 1);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 2);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 3);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 4);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 5);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 6);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 7);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 8);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 9);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (2, 10);

-- Snowpiercer
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 1);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 2);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 3);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 4);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 5);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 6);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 7);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 8);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (3, 9);

-- Mean Girls
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 1);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 2);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 3);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 4);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 5);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 6);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 7);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 8);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 9);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (4, 10);

-- The Craft
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (5, 1);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (5, 2);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (5, 3);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (5, 4);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (5, 5);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (5, 6);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (5, 7);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (5, 8);

-- Senior Year
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 1);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 2);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 3);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 4);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 5);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 6);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 7);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 8);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 9);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (6, 10);

-- Clueless
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 1);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 2);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 3);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 4);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 5);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 6);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 8);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 9);
INSERT INTO Subtitles (ContentID, LanguageID) VALUES (7, 10);

-- List

INSERT INTO List (UserID, ContentID) VALUES (1, 1);
INSERT INTO List (UserID, ContentID) VALUES (1, 4);
INSERT INTO List (UserID, ContentID) VALUES (1, 5);

INSERT INTO List (UserID, ContentID) VALUES (2, 7);

INSERT INTO List (UserID, ContentID) VALUES (3, 4);

INSERT INTO List (UserID, ContentID) VALUES (5, 2);

INSERT INTO List (UserID, ContentID) VALUES (8, 1);
INSERT INTO List (UserID, ContentID) VALUES (8, 7);

INSERT INTO List (UserID, ContentID) VALUES (9, 2);
INSERT INTO List (UserID, ContentID) VALUES (9, 3);
INSERT INTO List (UserID, ContentID) VALUES (9, 4);
INSERT INTO List (UserID, ContentID) VALUES (9, 6);

-- Watched

INSERT INTO Watched (UserID, ContentID) VALUES (1, 2);
INSERT INTO Watched (UserID, ContentID) VALUES (1, 3);

INSERT INTO Watched (UserID, ContentID) VALUES (3, 4);
INSERT INTO Watched (UserID, ContentID) VALUES (3, 7);

INSERT INTO Watched (UserID, ContentID) VALUES (8, 2);
INSERT INTO Watched (UserID, ContentID) VALUES (8, 7);

INSERT INTO Watched (UserID, ContentID) VALUES (9, 2);
INSERT INTO Watched (UserID, ContentID) VALUES (9, 4);
INSERT INTO Watched (UserID, ContentID) VALUES (9, 7);

INSERT INTO Watched (UserID, ContentID) VALUES (10, 1);
INSERT INTO Watched (UserID, ContentID) VALUES (10, 2);

-- Liked

INSERT INTO Liked (UserID, ContentID) VALUES (1, 1);
INSERT INTO Liked (UserID, ContentID) VALUES (1, 5);

INSERT INTO Liked (UserID, ContentID) VALUES (5, 2);

INSERT INTO Liked (UserID, ContentID) VALUES (6, 1);
INSERT INTO Liked (UserID, ContentID) VALUES (6, 2);

INSERT INTO Liked (UserID, ContentID) VALUES (8, 1);
INSERT INTO Liked (UserID, ContentID) VALUES (8, 2);
INSERT INTO Liked (UserID, ContentID) VALUES (8, 7);

INSERT INTO Liked (UserID, ContentID) VALUES (9, 2);
INSERT INTO Liked (UserID, ContentID) VALUES (9, 4);
INSERT INTO Liked (UserID, ContentID) VALUES (9, 7);

-- Device

INSERT INTO Device (IPAddress, UserID) VALUES ('124.34.5.1.2', 1);
INSERT INTO Device (IPAddress, UserID) VALUES ('192.168.0.1', 2);
INSERT INTO Device (IPAddress, UserID) VALUES ('10.0.0.1', 3);
INSERT INTO Device (IPAddress, UserID) VALUES ('172.16.0.1', 4);
INSERT INTO Device (IPAddress, UserID) VALUES ('192.168.1.1', 5);
INSERT INTO Device (IPAddress, UserID) VALUES ('203.0.113.1', 6);
INSERT INTO Device (IPAddress, UserID) VALUES ('198.51.100.1', 7);
INSERT INTO Device (IPAddress, UserID) VALUES ('172.31.0.1', 8);
INSERT INTO Device (IPAddress, UserID) VALUES ('10.10.10.1', 9);
INSERT INTO Device (IPAddress, UserID) VALUES ('192.168.2.1', 10);