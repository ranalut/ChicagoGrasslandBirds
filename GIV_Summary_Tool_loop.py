### Task: Clip and summarize ecosystem service valuation grids and associated landscape types based on user-selected input feature
### Author: Zach Vernon | Chicago Metropolitan Agency for Planning | zvernon@cmap.illinois.gov
### Revised: 03/26/2015
### Revised again on 06/09/2015 by Caitlin Jensen (National Audubon Society) to include a for loop that repeats the analysis for every feature of a feature class

import arcpy

# Parameters, variables, and environment settings
species = "boboli"
esv_grid = "D:/Chicago_Grasslands/GIS/GIV_Combined_Outputs.gdb/GIV2_3_EcosystemServiceValues"
ltypes_grid = "D:/Chicago_Grasslands/GIS/GIV_Landscape_Types.gdb/all_types_combined"
clip_feature = "D:/Chicago_Grasslands/GIS/Species_per_patch_final2.gdb/" + species + "_per_patch_final_sample"
#out_gdb = "C:/Chicago_Grasslands/GIV_Tool_Outputs.gdb"
out_path = "D:/Chicago_Grasslands/GIS/GIV_Tool_Outputs_" + species

arcpy.env.overwriteOutput=True

# Function to generate list with correct number of indices
def listBuild(numList):
	l1=[]
	for i in range(0,numList+1):
		l1.append(i)
	return l1

rows = arcpy.SearchCursor(clip_feature)

print "Starting loop..."

for row in rows:
	feat = row.shape
	patchID = str(row.patch_id)
	
	esv_out_table_name = "EcosystemService_Summary_" + species + patchID + "_sample.dbf"
##	ltypes_out_table_name = "GIV_LandscapeTypes_SummaryTable_" + species + str(row.new_id)
	
	esv_clip = 'in_memory/ESV_clip'
	esv_out_table = out_path + '/' + esv_out_table_name
##	ltypes_clip = 'in_memory/LTypes_clip'
##	ltypes_out_table = out_gdb+'/'+ltypes_out_table_name
	
	arcpy.Clip_management(esv_grid,'#',esv_clip,feat,None,'ClippingGeometry')
	print "Clipped feature " + patchID
	# Create list containing fields in clipped ESV
	esv_fields = [field.name for field in arcpy.ListFields(esv_clip)]

	# Create list to hold summarized ESV values
	esv_value_list = listBuild(6)

	# Multiple each field by cell count
	with arcpy.da.SearchCursor(esv_clip,esv_fields) as cursor:
		esv_value_list[0]='Dollar Value'
		esv_value_list[1]=patchID
		for row in cursor:
			esv_value_list[2]+=(row[esv_fields.index('FloodControl_DollarValue')]*row[esv_fields.index('Count')])
			esv_value_list[3]+=(row[esv_fields.index('GroundwaterRecharge_DollarValue')]*row[esv_fields.index('Count')])
			esv_value_list[4]+=(row[esv_fields.index('WaterPurification_DollarValue')]*row[esv_fields.index('Count')])
			esv_value_list[5]+=round((float(row[esv_fields.index('CarbonStorage_DollarValue')])*float(row[esv_fields.index('Count')])),0)
			esv_value_list[6]+=round((float(row[esv_fields.index('CombinedServices_DollarValue')])*float(row[esv_fields.index('Count')])),0)

	# Corrects final list values by subtracting list index value
	for i in range(2,7):
	    esv_value_list[i]-=i
	    esv_value_list[i]=esv_value_list[i]

	# Calc percent regional
##	esv_reg_list=listBuild(5)
##	esv_reg_list[0]='Percent Regional' 
##	esv_reg_list[1]=round((float(esv_value_list[1]/4202673258)*100),2)
##	esv_reg_list[2]=round((float(esv_value_list[2]/1528086249)*100),2)
##	esv_reg_list[3]=round((float(esv_value_list[3]/623499072)*100),2)
##	esv_reg_list[4]=round((float(esv_value_list[4]/11512817)*100),2)
##	esv_reg_list[5]=round((float(esv_value_list[5]/6365771396)*100),2)

	# Calc percent of aggregate services
	# esv_study_area_list=listBuild(5)
	# esv_study_area_list[0] = 'Percent Study Area'
	# esv_study_area_list[1] = round((float(esv_value_list[1])/float(esv_value_list[5])*100),2)
	# esv_study_area_list[2] = round((float(esv_value_list[2])/float(esv_value_list[5])*100),2)
	# esv_study_area_list[3] = round((float(esv_value_list[3])/float(esv_value_list[5])*100),2)
	# esv_study_area_list[4] = round((float(esv_value_list[4])/float(esv_value_list[5])*100),2)
	# esv_study_area_list[5] = 100.00

	# Create output table
	arcpy.CreateTable_management(out_path, esv_out_table_name)

	# Add fields to out_table
	arcpy.AddField_management(esv_out_table,'type','TEXT','50')
	arcpy.AddField_management(esv_out_table, 'patch_id', 'TEXT', '10')
	esv_out_field_list = ['Flood','Grndwtr','WaterPur','CarbonStor','Aggregate']
	for field in esv_out_field_list:
		arcpy.AddField_management(esv_out_table,field,'FLOAT')

	# Modify out field list to match insert list
	esv_out_field_list.insert(0,'type')
	esv_out_field_list.insert(1,'patch_id')

	# Write sum values row to out table
	with arcpy.da.InsertCursor(esv_out_table,esv_out_field_list) as cursor:
		cursor.insertRow(esv_value_list)
		#cursor.insertRow(esv_reg_list)
		#cursor.insertRow(esv_study_area_list)

      
##      ### Section controlling Landscape Type summary ###
##      # Clip landscape types raster and store in-memory
##      arcpy.Clip_management(ltypes_grid,'#',ltypes_clip,feat,None,'ClippingGeometry')
##
##      # Create list containing fields in clipped ESV
##      ltypes_fields = [field.name for field in arcpy.ListFields(ltypes_clip)]
##
##      # Create list to hold summarized landscape type cell counts
##      ltypes_list = listBuild(31)
##
##      # Create variable to hold study area cell count
##      ltypes_study_area_count=0
##
##      # Multiple each field by cell count
##      with arcpy.da.SearchCursor(ltypes_clip,ltypes_fields) as cursor:
##              for row in cursor:
##                      ltypes_list[0]+=(row[ltypes_fields.index('hub_ly1')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[1]+=(row[ltypes_fields.index('hub_ly2')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[2]+=(row[ltypes_fields.index('hub_ly3')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[3]+=(row[ltypes_fields.index('forest_ly1')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[4]+=(row[ltypes_fields.index('forest_ly2')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[5]+=(row[ltypes_fields.index('forest_ly3a')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[6]+=(row[ltypes_fields.index('forest_ly3b')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[7]+=(row[ltypes_fields.index('forest_ly4')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[8]+=(row[ltypes_fields.index('forest_ly5')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[9]+=(row[ltypes_fields.index('forest_ly6')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[10]+=(row[ltypes_fields.index('forest_ly7')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[11]+=(row[ltypes_fields.index('pgs_ly1')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[12]+=(row[ltypes_fields.index('pgs_ly2')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[13]+=(row[ltypes_fields.index('pgs_ly3')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[14]+=(row[ltypes_fields.index('pgs_ly4')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[15]+=(row[ltypes_fields.index('pgs_ly5')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[16]+=(row[ltypes_fields.index('pgs_ly6')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[17]+=(row[ltypes_fields.index('pgs_ly7')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[18]+=(row[ltypes_fields.index('stream_ly1')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[19]+=(row[ltypes_fields.index('stream_ly2')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[20]+=(row[ltypes_fields.index('stream_ly3')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[21]+=(row[ltypes_fields.index('stream_ly4')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[22]+=(row[ltypes_fields.index('stream_ly5')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[23]+=(row[ltypes_fields.index('wetland_ly1')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[24]+=(row[ltypes_fields.index('wetland_ly2')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[25]+=(row[ltypes_fields.index('wetland_ly3')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[26]+=(row[ltypes_fields.index('wetland_ly4a')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[27]+=(row[ltypes_fields.index('wetland_ly4b')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[28]+=(row[ltypes_fields.index('wetland_ly5')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[29]+=(row[ltypes_fields.index('wetland_ly6')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[30]+=(row[ltypes_fields.index('wetland_ly7')]*row[ltypes_fields.index('Count')])
##                      ltypes_list[31]+=(row[ltypes_fields.index('wetland_ly8')]*row[ltypes_fields.index('Count')])
##
##                      # Get cell count for entire study area
##                      ltypes_study_area_count+=row[ltypes_fields.index('Count')]
##      
##      # Corrects final list values by subtracting list index value
##      for i in range(1,32):
##          ltypes_list[i]-=i
##          ltypes_list[i] = ltypes_list[i]
##
##      # Create list to hold summarized landscape type acreage
##      ltypes_acreage_list = listBuild(31)
##
##      # Calculate acreage
##      for i in range(0,32):
##              ltypes_acreage_list[i] = round((float(ltypes_list[i])*0.222395),2)
##      ltypes_study_area_acreage = round((float(ltypes_study_area_count)*0.222395),2)
##      
##      # Calculate core acreage
##      core_for_acres = round(float(ltypes_acreage_list[5])+float(ltypes_acreage_list[6])+float(ltypes_acreage_list[7]),2)
##      core_pgs_acres = round(float(ltypes_acreage_list[11])+float(ltypes_acreage_list[12]),2)
##      core_wld_acres = round(float(ltypes_acreage_list[26])+float(ltypes_acreage_list[27])+float(ltypes_acreage_list[28]),2)
##      core_wat_acres = round(float(ltypes_acreage_list[20]),2)
##
##      ltypes_acreage_list.insert(0,'Acreage')
##      ltypes_acreage_list.insert(1,core_for_acres)
##      ltypes_acreage_list.insert(2,core_pgs_acres)
##      ltypes_acreage_list.insert(3,core_wld_acres)
##      ltypes_acreage_list.insert(4,core_wat_acres)
##
##      # Create output table
##      arcpy.CreateTable_management(out_gdb,ltypes_out_table_name)
##
##      # Add fields to out_table
##      arcpy.AddField_management(ltypes_out_table,'type','TEXT','30')
##      ltypes_out_field_list = ['core_woodland_forest','core_prairie_grassland','core_wetlands','core_lakes_streams','giv_ecological_networks','giv_protected_lands','giv_composite','forest_ly1','forest_ly2','forest_ly3a','forest_ly3b','forest_ly4','forest_ly5','forest_ly6','forest_ly7','pgs_ly1','pgs_ly2','pgs_ly3','pgs_ly4','pgs_ly5','pgs_ly6','pgs_ly7','stream_ly1','stream_ly2','stream_ly3','stream_ly4','stream_ly5','wetland_ly1','wetland_ly2','wetland_ly3','wetland_ly4a','wetland_ly4b','wetland_ly5','wetland_ly6','wetland_ly7','wetland_ly8']
##      for field in ltypes_out_field_list:
##              arcpy.AddField_management(ltypes_out_table,field,'FLOAT')
##
##      # Modify out field list to match insert list
##      ltypes_out_field_list.insert(0,'type')
##
##      # Create list to hold regional landscape type percentages
##      ltypes_reg_list = listBuild(36)
##      ltypes_reg_list[0]='Percent Regional'
##      ltypes_reg_list[1]=round(((float(ltypes_acreage_list[1])/float(114329.2578125))*100),2)
##      ltypes_reg_list[2]=round(((float(ltypes_acreage_list[2])/float(22629.140625))*100),2)
##      ltypes_reg_list[3]=round(((float(ltypes_acreage_list[3])/float(61207.9882813))*100),2)
##      ltypes_reg_list[4]=round(((float(ltypes_acreage_list[4])/float(108993.1171875))*100),2)
##      ltypes_reg_list[5]=round(((float(ltypes_acreage_list[5])/float(548988.9375))*100),2)
##      ltypes_reg_list[6]=round(((float(ltypes_acreage_list[6])/float(323802.875))*100),2)
##      ltypes_reg_list[7]=round(((float(ltypes_acreage_list[7])/float(814498.75))*100),2)
##      ltypes_reg_list[8]=round(((float(ltypes_acreage_list[8])/float(140279.875))*100),2)
##      ltypes_reg_list[9]=round(((float(ltypes_acreage_list[9])/float(96675.109375))*100),2)
##      ltypes_reg_list[10]=round(((float(ltypes_acreage_list[10])/float(2345.3798828))*100),2)
##      ltypes_reg_list[11]=round(((float(ltypes_acreage_list[11])/float(12184.3496094))*100),2)
##      ltypes_reg_list[12]=round(((float(ltypes_acreage_list[12])/float(99799.53125))*100),2)
##      ltypes_reg_list[13]=round(((float(ltypes_acreage_list[13])/float(143914.46875))*100),2)
##      ltypes_reg_list[14]=round(((float(ltypes_acreage_list[14])/float(243403.984375))*100),2)
##      ltypes_reg_list[15]=round(((float(ltypes_acreage_list[15])/float(114715.5703125))*100),2)
##      ltypes_reg_list[16]=round(((float(ltypes_acreage_list[16])/float(21089.5))*100),2)
##      ltypes_reg_list[17]=round(((float(ltypes_acreage_list[17])/float(1539.6400146))*100),2)
##      ltypes_reg_list[18]=round(((float(ltypes_acreage_list[18])/float(24638.0292969))*100),2)
##      ltypes_reg_list[19]=round(((float(ltypes_acreage_list[19])/float(760551.5625))*100),2)
##      ltypes_reg_list[20]=round(((float(ltypes_acreage_list[20])/float(37371.03125))*100),2)
##      ltypes_reg_list[21]=round(((float(ltypes_acreage_list[21])/float(40547.9492188))*100),2)
##      ltypes_reg_list[22]=round(((float(ltypes_acreage_list[22])/float(227949.984375))*100),2)
##      ltypes_reg_list[23]=round(((float(ltypes_acreage_list[23])/float(345764.1875))*100),2)
##      ltypes_reg_list[24]=round(((float(ltypes_acreage_list[24])/float(210567.140625))*100),2)
##      ltypes_reg_list[25]=round(((float(ltypes_acreage_list[25])/float(108993.1171875))*100),2)
##      ltypes_reg_list[26]=round(((float(ltypes_acreage_list[26])/float(361484.375))*100),2)
##      ltypes_reg_list[27]=round(((float(ltypes_acreage_list[27])/float(218380.09375))*100),2)
##      ltypes_reg_list[28]=round(((float(ltypes_acreage_list[28])/float(178927.015625))*100),2)
##      ltypes_reg_list[29]=round(((float(ltypes_acreage_list[29])/float(35052.1210938))*100),2)
##      ltypes_reg_list[30]=round(((float(ltypes_acreage_list[30])/float(69886.2890625))*100),2)
##      ltypes_reg_list[31]=round(((float(ltypes_acreage_list[31])/float(6352.2700195))*100),2)
##      ltypes_reg_list[32]=round(((float(ltypes_acreage_list[32])/float(13472.2402344))*100),2)
##      ltypes_reg_list[33]=round(((float(ltypes_acreage_list[33])/float(41383.4804688))*100),2)
##      ltypes_reg_list[34]=round(((float(ltypes_acreage_list[34])/float(63623.8710938))*100),2)
##      ltypes_reg_list[35]=round(((float(ltypes_acreage_list[35])/float(469180.71875))*100),2)
##      ltypes_reg_list[36]=round(((float(ltypes_acreage_list[36])/float(115903.6015625))*100),2)
##
##      # Create list to hold regional landscape type percentages
##      ltypes_study_area_list = listBuild(36)
##      ltypes_study_area_list[0]='Percent Study Area'
##      ltypes_study_area_list[1]=round(((float(ltypes_acreage_list[1])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[2]=round(((float(ltypes_acreage_list[2])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[3]=round(((float(ltypes_acreage_list[3])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[4]=round(((float(ltypes_acreage_list[4])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[5]=round(((float(ltypes_acreage_list[5])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[6]=round(((float(ltypes_acreage_list[6])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[7]=round(((float(ltypes_acreage_list[7])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[8]=round(((float(ltypes_acreage_list[8])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[9]=round(((float(ltypes_acreage_list[9])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[10]=round(((float(ltypes_acreage_list[10])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[11]=round(((float(ltypes_acreage_list[11])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[12]=round(((float(ltypes_acreage_list[12])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[13]=round(((float(ltypes_acreage_list[13])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[14]=round(((float(ltypes_acreage_list[14])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[15]=round(((float(ltypes_acreage_list[15])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[16]=round(((float(ltypes_acreage_list[16])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[17]=round(((float(ltypes_acreage_list[17])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[18]=round(((float(ltypes_acreage_list[18])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[19]=round(((float(ltypes_acreage_list[19])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[20]=round(((float(ltypes_acreage_list[20])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[21]=round(((float(ltypes_acreage_list[21])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[22]=round(((float(ltypes_acreage_list[22])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[23]=round(((float(ltypes_acreage_list[23])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[24]=round(((float(ltypes_acreage_list[24])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[25]=round(((float(ltypes_acreage_list[25])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[26]=round(((float(ltypes_acreage_list[26])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[27]=round(((float(ltypes_acreage_list[27])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[28]=round(((float(ltypes_acreage_list[28])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[29]=round(((float(ltypes_acreage_list[29])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[30]=round(((float(ltypes_acreage_list[30])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[31]=round(((float(ltypes_acreage_list[31])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[32]=round(((float(ltypes_acreage_list[32])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[33]=round(((float(ltypes_acreage_list[33])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[34]=round(((float(ltypes_acreage_list[34])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[35]=round(((float(ltypes_acreage_list[35])/float(ltypes_study_area_acreage))*100),2)
##      ltypes_study_area_list[36]=round(((float(ltypes_acreage_list[36])/float(ltypes_study_area_acreage))*100),2)
##
##      # Write sum values row to out table
##      with arcpy.da.InsertCursor(ltypes_out_table,ltypes_out_field_list) as cursor:
##              cursor.insertRow(ltypes_acreage_list)
##              cursor.insertRow(ltypes_reg_list)
##              cursor.insertRow(ltypes_study_area_list)
##
