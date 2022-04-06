//to use before 'extract_auto_save.ijm' to find params for an fov


/* APPROACH FOR USE
 *  1. open PC image for FOV of interest
 *  2. Open Plugins > Macros > Record
 *  3. select first trench using the rectangle tool
 *  4. using values from the "recorder" tab, modify the below parameters
 *  	make sure to check the spacing is working well! can move the 
 *  	rectangle selection to ensure that the spacing is correct
 *  	run script - will save to folder selected
 *//* APPROACH FOR USE
 *  1. open PC image for FOV of interest
 *  2. Open Plugins > Macros > Record
 *  3. select first trench using the rectangle tool
 *  4. using values from the "recorder" tab, modify the below parameters
 *  	make sure to check the spacing is working well! can move the 
 *  	rectangle selection to ensure that the spacing is correct
 *  	run script - will save to folder selected
 */
 //VARIABLES
fov = "xy000"

//
run("Close All");
run("Record...");
dir_folder = "C:/Users/student/Desktop/exp1/"+fov +"/"			//folder with tiff stacks for each channel of FOV
run("TIFF Virtual Stack...", "open="+dir_folder+fov+"_PC.tif");
makeRectangle(122, 218, 80, 1100);