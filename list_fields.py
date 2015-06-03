import arcpy

fc = "C:/Chicago_Grasslands/Species_per_patch/Species_per_patch.gdb/cmap_counties"
field_names = [f.name for f in arcpy.ListFields(fc)]
print field_names
