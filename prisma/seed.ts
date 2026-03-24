import {
  PrismaClient,
  RegattaTier,
  RegattaStatus,
  RaceType,
  RaceStatus,
  ResultStatus,
  ScraperRunStatus,
} from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  console.log('Seeding database...')

  // Season
  const season = await prisma.season.upsert({
    where: { year: 2026 },
    update: {},
    create: { year: 2026, label: '2026 Season' },
  })

  // Schools
  const pbhs = await prisma.school.upsert({
    where: { name: 'Pretoria Boys High School' },
    update: {},
    create: { name: 'Pretoria Boys High School', shortName: 'PBHS' },
  })

  const stalbs = await prisma.school.upsert({
    where: { name: "St Alban's College" },
    update: {},
    create: { name: "St Alban's College", shortName: 'Stalbs' },
  })

  const affies = await prisma.school.upsert({
    where: { name: 'Afrikaanse Hoër Seunskool' },
    update: {},
    create: { name: 'Afrikaanse Hoër Seunskool', shortName: 'Affies' },
  })

  // School alias
  await prisma.schoolAlias.upsert({
    where: { alias: 'Pretoria Boys' },
    update: {},
    create: { alias: 'Pretoria Boys', schoolId: pbhs.id },
  })

  // Rowers
  const rower1 = await prisma.rower.upsert({
    where: {
      firstName_lastName_currentSchoolId: {
        firstName: 'James',
        lastName: 'Smith',
        currentSchoolId: pbhs.id,
      },
    },
    update: {},
    create: { firstName: 'James', lastName: 'Smith', currentSchoolId: pbhs.id },
  })

  const rower2 = await prisma.rower.upsert({
    where: {
      firstName_lastName_currentSchoolId: {
        firstName: 'John',
        lastName: 'Doe',
        currentSchoolId: stalbs.id,
      },
    },
    update: {},
    create: { firstName: 'John', lastName: 'Doe', currentSchoolId: stalbs.id },
  })

  const rower3 = await prisma.rower.upsert({
    where: {
      firstName_lastName_currentSchoolId: {
        firstName: 'Luca',
        lastName: 'van der Berg',
        currentSchoolId: affies.id,
      },
    },
    update: {},
    create: {
      firstName: 'Luca',
      lastName: 'van der Berg',
      currentSchoolId: affies.id,
    },
  })

  // School history (current season)
  for (const { rowerId, schoolId } of [
    { rowerId: rower1.id, schoolId: pbhs.id },
    { rowerId: rower2.id, schoolId: stalbs.id },
    { rowerId: rower3.id, schoolId: affies.id },
  ]) {
    await prisma.rowerSchoolHistory.upsert({
      where: { rowerId_seasonId: { rowerId, seasonId: season.id } },
      update: {},
      create: { rowerId, schoolId, seasonId: season.id },
    })
  }

  // Regatta
  const regatta = await prisma.regatta.upsert({
    where: { sourceUrl: 'http://regattaresults.co.za/test/kes2026' },
    update: {},
    create: {
      name: 'KES Regatta 2026',
      sourceUrl: 'http://regattaresults.co.za/test/kes2026',
      seasonId: season.id,
      tier: RegattaTier.REGIONAL,
      status: RegattaStatus.RESULTS_FINAL,
      startDate: new Date('2026-03-14'),
      endDate: new Date('2026-03-15'),
    },
  })

  // Event
  const event = await prisma.event.upsert({
    where: {
      regattaId_name: { regattaId: regatta.id, name: 'JM16 1x' },
    },
    update: {},
    create: {
      regattaId: regatta.id,
      name: 'JM16 1x',
      ageGroup: 'U16',
      boatClass: '1x',
      gender: 'Boys',
    },
  })

  // Race — A Final (find existing or create)
  let race = await prisma.race.findFirst({
    where: {
      eventId: event.id,
      raceType: RaceType.FINAL_A,
    },
  })
  if (!race) {
    race = await prisma.race.create({
      data: {
        eventId: event.id,
        raceType: RaceType.FINAL_A,
        status: RaceStatus.COMPLETE,
      },
    })
  }

  // Results (use upsert on unique [raceId, schoolId])
  const result1 = await prisma.result.upsert({
    where: {
      raceId_schoolId: { raceId: race.id, schoolId: pbhs.id },
    },
    update: {},
    create: {
      raceId: race.id,
      schoolId: pbhs.id,
      lane: 3,
      placement: 1,
      finishTimeMs: 220150,
      resultStatus: ResultStatus.FINISHED,
      points: 8,
    },
  })

  const result2 = await prisma.result.upsert({
    where: {
      raceId_schoolId: { raceId: race.id, schoolId: stalbs.id },
    },
    update: {},
    create: {
      raceId: race.id,
      schoolId: stalbs.id,
      lane: 4,
      placement: 2,
      finishTimeMs: 224500,
      resultStatus: ResultStatus.FINISHED,
      points: 7,
    },
  })

  const result3 = await prisma.result.upsert({
    where: {
      raceId_schoolId: { raceId: race.id, schoolId: affies.id },
    },
    update: {},
    create: {
      raceId: race.id,
      schoolId: affies.id,
      lane: 5,
      placement: 3,
      finishTimeMs: 228900,
      resultStatus: ResultStatus.FINISHED,
      points: 6,
    },
  })

  // Crew linkages (find-or-create pattern)
  for (const { resultId, rowerId, seatNumber } of [
    { resultId: result1.id, rowerId: rower1.id, seatNumber: 1 },
    { resultId: result2.id, rowerId: rower2.id, seatNumber: 1 },
    { resultId: result3.id, rowerId: rower3.id, seatNumber: 1 },
  ]) {
    const existing = await prisma.resultRower.findFirst({
      where: { resultId, rowerId },
    })
    if (!existing) {
      await prisma.resultRower.create({
        data: { resultId, rowerId, seatNumber },
      })
    }
  }

  // Personal Bests
  for (const { rowerId, resultId, finishTimeMs } of [
    { rowerId: rower1.id, resultId: result1.id, finishTimeMs: 220150 },
    { rowerId: rower2.id, resultId: result2.id, finishTimeMs: 224500 },
    { rowerId: rower3.id, resultId: result3.id, finishTimeMs: 228900 },
  ]) {
    await prisma.personalBest.upsert({
      where: {
        rowerId_boatClass_ageGroup: {
          rowerId,
          boatClass: '1x',
          ageGroup: 'U16',
        },
      },
      update: { finishTimeMs, resultId, achievedAt: new Date('2026-03-15') },
      create: {
        rowerId,
        boatClass: '1x',
        ageGroup: 'U16',
        finishTimeMs,
        resultId,
        achievedAt: new Date('2026-03-15'),
      },
    })
  }

  // School rivalry record
  const [aId, bId] = [pbhs.id, stalbs.id].sort()
  await prisma.schoolRivalry.upsert({
    where: {
      schoolAId_schoolBId: { schoolAId: aId!, schoolBId: bId! },
    },
    update: { winsA: 1, winsB: 0, draws: 0, totalRaces: 1 },
    create: {
      schoolAId: aId!,
      schoolBId: bId!,
      winsA: 1,
      winsB: 0,
      draws: 0,
      totalRaces: 1,
    },
  })

  // Scraper log (find-or-create pattern)
  const existingLog = await prisma.scraperLog.findFirst({
    where: {
      regattaId: regatta.id,
      regattaUrl: 'http://regattaresults.co.za/test/kes2026',
    },
  })
  if (!existingLog) {
    await prisma.scraperLog.create({
      data: {
        regattaId: regatta.id,
        regattaUrl: 'http://regattaresults.co.za/test/kes2026',
        status: ScraperRunStatus.SUCCESS,
        startedAt: new Date(),
        completedAt: new Date(),
        durationMs: 1240,
        eventsScanned: 1,
        racesScanned: 1,
        resultsCreated: 3,
        resultsUpdated: 0,
        notificationsCreated: 0,
      },
    })
  }

  // Erg score example (find-or-create pattern)
  const existingErg = await prisma.ergScore.findFirst({
    where: { rowerId: rower1.id, distanceM: 2000 },
  })
  if (!existingErg) {
    await prisma.ergScore.create({
      data: {
        rowerId: rower1.id,
        distanceM: 2000,
        timeMs: 390000,
        recordedAt: new Date('2026-02-01'),
        notes: 'Pre-season baseline',
      },
    })
  }

  console.log('Seed complete.')
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(() => prisma.$disconnect())
