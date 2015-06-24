import csv
import math

fileName = 'Will_top10_allspecies'

checkIds = []

allPatchesDicts = []

patchStaging = []
patchStaging2 = []
patchStagingSorted3 = []

with open(fileName+'.csv', 'rb') as csvFile:

	inputData = csv.reader(csvFile, delimiter=',', quotechar='|')

	#skip header
	next(inputData, None)
	next(inputData, None)
	next(inputData, None)

	birdRank = 1

	for row in inputData:
		print

		rankModulo = int((birdRank/float(2)) % 16)
		check = ''
		status = row[4].strip('"')
		patchId = row[3]
		species = row[1].strip('"')
		count = row[6]

		if status == 'unprotected':

			check = patchId +'u'

		elif status == 'protected':

			check = patchId + 'p'

		#check to see if object with patchId & status already exists
		#create new object if it doesn't exist
		if (check not in checkIds) and (patchId != 'NA'):

			county = row[2].strip('"')
			acreage = row[5]
			floodControl = row[7]
			groundwaterRecharge = row[8]
			waterPurification = row[9]
			carbonSequestration = row[10]
			allServices = row[11]

			#data model for new row
			tempRow = { 'county': county,
				'patchId': patchId,
				'status': status,
				'acreage': acreage,
				'boboli': 'N/A',
				'easmea': 'N/A',
				'graspa': 'N/A',
				'henspa': 'N/A',
				'sedwre': 'N/A',
				'floodControl': floodControl,
				'groundwaterRecharge': groundwaterRecharge,
				'waterPurification': waterPurification,
				'carbonSequestration': carbonSequestration,
				'allServices': allServices
			}

			if status == 'unprotected':
				
				tempRow[species] = count + ' (' + str(rankModulo) +')'

			elif status == 'protected':

				tempRow[species] = count

			allPatchesDicts.append(tempRow)

			checkIds.append(check)


		#update species count if patch/status object exists
		elif check in checkIds:

			for patch in allPatchesDicts:

				if patch['patchId'] == patchId and patch['status'] == status:

					if status == 'unprotected':

						patch[species] = count + ' (' + str(rankModulo) +')'

					elif status == 'protected':

						patch[species] = count


		birdRank += 1

	unprotectedPatchesDicts = []
	protectedPatchesDicts = []

	for patch in allPatchesDicts:
		
		if patch['status'] == 'unprotected':

			unprotectedPatchesDicts.append(patch)

		elif patch['status'] == 'protected':

			protectedPatchesDicts.append(patch)


	for patch in unprotectedPatchesDicts:
		
		tempPatch = []

		tempPatch.append(patch['county'])
		tempPatch.append(patch['patchId'])
		tempPatch.append(patch['status'])
		tempPatch.append(patch['acreage'])
		tempPatch.append(patch['boboli'])
		tempPatch.append(patch['easmea'])
		tempPatch.append(patch['graspa'])
		tempPatch.append(patch['henspa'])
		tempPatch.append(patch['sedwre'])
		tempPatch.append(patch['floodControl'])
		tempPatch.append(patch['groundwaterRecharge'])
		tempPatch.append(patch['waterPurification'])
		tempPatch.append(patch['carbonSequestration'])
		tempPatch.append(patch['allServices'])

		patchStaging.append(tempPatch)

	patchStagingSorted = sorted(patchStaging, key = lambda x: int(x[3]), reverse=True)



	#print patchStagingSorted

	for patch2 in patchStagingSorted:

		for patch in protectedPatchesDicts:

			if patch2[1] == patch['patchId']:

				tempPatch = []

				tempPatch.append(patch['county'])
				tempPatch.append(patch['patchId'])
				tempPatch.append(patch['status'])
				tempPatch.append(patch['acreage'])
				tempPatch.append(patch['boboli'])
				tempPatch.append(patch['easmea'])
				tempPatch.append(patch['graspa'])
				tempPatch.append(patch['henspa'])
				tempPatch.append(patch['sedwre'])
				tempPatch.append(patch['floodControl'])
				tempPatch.append(patch['groundwaterRecharge'])
				tempPatch.append(patch['waterPurification'])
				tempPatch.append(patch['carbonSequestration'])
				tempPatch.append(patch['allServices'])

				patchStagingSorted3.append(tempPatch)
				patchStagingSorted3.append(patch2)


with open('Will_top10_final.csv', 'w') as output_file:
	dw = csv.writer(output_file, patchStagingSorted3, delimiter=',')
	dw.writerow(['County', 'Patch.Id', 'Status', 'Acreage', '#.Boboli',
	'#.Easmea', '#.Graspa', '#.Henspa', '#.Sedwre', 'Flood.Control',
	'Groundwater.Recharge', 'Water.Purification', 'Carbon.Sequestration',
	'All.Services'])
	dw.writerows(patchStagingSorted3)


