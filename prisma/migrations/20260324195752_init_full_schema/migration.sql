-- CreateTable
CREATE TABLE "Season" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "year" INTEGER NOT NULL,
    "label" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Regatta" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "sourceUrl" TEXT NOT NULL,
    "seasonId" TEXT NOT NULL,
    "tier" TEXT NOT NULL DEFAULT 'REGIONAL',
    "status" TEXT NOT NULL DEFAULT 'UPCOMING',
    "startDate" DATETIME,
    "endDate" DATETIME,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Regatta_seasonId_fkey" FOREIGN KEY ("seasonId") REFERENCES "Season" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Event" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "regattaId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "ageGroup" TEXT NOT NULL,
    "boatClass" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "sourceUrl" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Event_regattaId_fkey" FOREIGN KEY ("regattaId") REFERENCES "Regatta" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Race" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "eventId" TEXT NOT NULL,
    "raceType" TEXT NOT NULL,
    "heatNumber" INTEGER,
    "status" TEXT NOT NULL DEFAULT 'DRAW',
    "sourceUrl" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Race_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Result" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "raceId" TEXT NOT NULL,
    "schoolId" TEXT NOT NULL,
    "lane" INTEGER,
    "placement" INTEGER,
    "finishTimeMs" INTEGER,
    "resultStatus" TEXT NOT NULL DEFAULT 'FINISHED',
    "points" INTEGER NOT NULL DEFAULT 0,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Result_raceId_fkey" FOREIGN KEY ("raceId") REFERENCES "Race" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Result_schoolId_fkey" FOREIGN KEY ("schoolId") REFERENCES "School" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ResultRower" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "resultId" TEXT NOT NULL,
    "rowerId" TEXT NOT NULL,
    "seatNumber" INTEGER,
    CONSTRAINT "ResultRower_resultId_fkey" FOREIGN KEY ("resultId") REFERENCES "Result" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "ResultRower_rowerId_fkey" FOREIGN KEY ("rowerId") REFERENCES "Rower" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "School" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "shortName" TEXT,
    "isMasters" BOOLEAN NOT NULL DEFAULT false,
    "isUniversity" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "SchoolAlias" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "schoolId" TEXT NOT NULL,
    "alias" TEXT NOT NULL,
    CONSTRAINT "SchoolAlias_schoolId_fkey" FOREIGN KEY ("schoolId") REFERENCES "School" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SchoolRivalry" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "schoolAId" TEXT NOT NULL,
    "schoolBId" TEXT NOT NULL,
    "winsA" INTEGER NOT NULL DEFAULT 0,
    "winsB" INTEGER NOT NULL DEFAULT 0,
    "draws" INTEGER NOT NULL DEFAULT 0,
    "totalRaces" INTEGER NOT NULL DEFAULT 0,
    "lastUpdated" DATETIME NOT NULL,
    CONSTRAINT "SchoolRivalry_schoolAId_fkey" FOREIGN KEY ("schoolAId") REFERENCES "School" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "SchoolRivalry_schoolBId_fkey" FOREIGN KEY ("schoolBId") REFERENCES "School" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Rower" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "currentSchoolId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Rower_currentSchoolId_fkey" FOREIGN KEY ("currentSchoolId") REFERENCES "School" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "RowerSchoolHistory" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "rowerId" TEXT NOT NULL,
    "schoolId" TEXT NOT NULL,
    "seasonId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "RowerSchoolHistory_rowerId_fkey" FOREIGN KEY ("rowerId") REFERENCES "Rower" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "RowerSchoolHistory_schoolId_fkey" FOREIGN KEY ("schoolId") REFERENCES "School" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "RowerSchoolHistory_seasonId_fkey" FOREIGN KEY ("seasonId") REFERENCES "Season" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "PersonalBest" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "rowerId" TEXT NOT NULL,
    "boatClass" TEXT NOT NULL,
    "ageGroup" TEXT NOT NULL,
    "finishTimeMs" INTEGER NOT NULL,
    "resultId" TEXT NOT NULL,
    "achievedAt" DATETIME NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "PersonalBest_rowerId_fkey" FOREIGN KEY ("rowerId") REFERENCES "Rower" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "PersonalBest_resultId_fkey" FOREIGN KEY ("resultId") REFERENCES "Result" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ErgScore" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "rowerId" TEXT NOT NULL,
    "distanceM" INTEGER,
    "durationS" INTEGER,
    "timeMs" INTEGER NOT NULL,
    "recordedAt" DATETIME NOT NULL,
    "notes" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "ErgScore_rowerId_fkey" FOREIGN KEY ("rowerId") REFERENCES "Rower" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "WeatherLog" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "regattaId" TEXT NOT NULL,
    "recordedAt" DATETIME NOT NULL,
    "windSpeedKph" REAL,
    "windDirectionDeg" INTEGER,
    "coachRating" INTEGER,
    "notes" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "WeatherLog_regattaId_fkey" FOREIGN KEY ("regattaId") REFERENCES "Regatta" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "AppUser" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "cookieToken" TEXT NOT NULL,
    "pinnedSchoolId" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "schoolId" TEXT NOT NULL,
    "eventName" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "ScraperLog" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "regattaId" TEXT,
    "regattaUrl" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "startedAt" DATETIME NOT NULL,
    "completedAt" DATETIME,
    "durationMs" INTEGER,
    "eventsScanned" INTEGER NOT NULL DEFAULT 0,
    "racesScanned" INTEGER NOT NULL DEFAULT 0,
    "resultsCreated" INTEGER NOT NULL DEFAULT 0,
    "resultsUpdated" INTEGER NOT NULL DEFAULT 0,
    "notificationsCreated" INTEGER NOT NULL DEFAULT 0,
    "errors" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "ScraperLog_regattaId_fkey" FOREIGN KEY ("regattaId") REFERENCES "Regatta" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Season_year_key" ON "Season"("year");

-- CreateIndex
CREATE UNIQUE INDEX "Regatta_sourceUrl_key" ON "Regatta"("sourceUrl");

-- CreateIndex
CREATE UNIQUE INDEX "Event_regattaId_name_key" ON "Event"("regattaId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Result_raceId_schoolId_key" ON "Result"("raceId", "schoolId");

-- CreateIndex
CREATE UNIQUE INDEX "School_name_key" ON "School"("name");

-- CreateIndex
CREATE UNIQUE INDEX "SchoolAlias_alias_key" ON "SchoolAlias"("alias");

-- CreateIndex
CREATE UNIQUE INDEX "SchoolRivalry_schoolAId_schoolBId_key" ON "SchoolRivalry"("schoolAId", "schoolBId");

-- CreateIndex
CREATE UNIQUE INDEX "Rower_firstName_lastName_currentSchoolId_key" ON "Rower"("firstName", "lastName", "currentSchoolId");

-- CreateIndex
CREATE UNIQUE INDEX "RowerSchoolHistory_rowerId_seasonId_key" ON "RowerSchoolHistory"("rowerId", "seasonId");

-- CreateIndex
CREATE UNIQUE INDEX "PersonalBest_rowerId_boatClass_ageGroup_key" ON "PersonalBest"("rowerId", "boatClass", "ageGroup");

-- CreateIndex
CREATE UNIQUE INDEX "AppUser_cookieToken_key" ON "AppUser"("cookieToken");
