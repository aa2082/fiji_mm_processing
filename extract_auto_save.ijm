//extracts trenches from a single fov for multiple channels
//need two tiff stacks saved in the same folder for the given fov

/* APPROACH FOR USE
 *  1. open PC image for FOV of interest
 *  2. Open Plugins > Macros > Record
 *  3. select first trench using the rectangle tool
 *  4. using values from the "recorder" tab, modify the below parameters
 *  	make sure to check the spacing is working well! can move the 
 *  	rectangle selection to ensure that the spacing is correct
 *  	run script - will save to folder selected
 */

//params - check using the macro recorder
fov = "xy000" //CHECK THESE 4 BEFORE RUNNING!
left_ROI_x = 122;	//122 initially
ROI_y = 218;		//218 initially
n_trenches = 9;

//
ROI_w = 80;
ROI_h = 1100;
ROI_gap = 259;// estimate from the line profile across trenches

dir_folder = "C:/Users/student/Desktop/exp1/"+fov +"/"			//folder with tiff stacks for each channel of FOV
dir_save = "C:/Users/student/Desktop/exp1_extract/"				//where results will be stored
File.makeDirectory(dir_save);
dir_save_fov = dir_save + fov+"/"
File.makeDirectory(dir_save_fov);

//setup
run("Close All");

//for (i = 0; i < 2; i++) {
//	if(i==0){channel = "mCherry";}
//	if(i==1){channel = "YFP";}
	channel="mCherry";
	//CREATE FOLDERS
	dir_save_fov_ch = dir_save_fov+channel+"/";
	File.makeDirectory(dir_save_fov_ch);
	
	dirROI =  dir_save_fov_ch + "ROI/";
	dirKymo = dir_save_fov_ch + "Kymo/";
	File.makeDirectory(dirROI);
	File.makeDirectory(dirKymo);
	
	dir_file = dir_folder+fov+"_"+channel;	
	/*following file format:
	 * dir_folder>fov>
	 * 					$(fov)_channel1_name.tif
	 * 					$(fov)_channel2_name.tif
	 */
	 
	//open image file
	open(dir_file+".tif");
	name = getTitle();
	
	//extract trenches
	selectWindow(name);
	for (i=0; i<n_trenches; i++) {
	    shift_x = floor(ROI_gap*i);
	    ROI_x = left_ROI_x+shift_x;
	    print(ROI_x);
	    makeRectangle(ROI_x, ROI_y, ROI_w, ROI_h);
	    run("Duplicate...", "duplicate");
	    name_ROI = fov+"_tr_"+i;
	    saveAs("Tiff", dirROI+name_ROI);
	    run("Make Montage...", "columns=180 rows=3 scale=1 label");
	    name_Kymo = fov+"_tr_"+i;
	    saveAs("Tiff", dirKymo+name_Kymo);
	 //Next round!
	     selectWindow(name);
	}
	run("Close All");
	
	channel="YFP";
	//CREATE FOLDERS
	dir_save_fov_ch = dir_save_fov+channel+"/";
	File.makeDirectory(dir_save_fov_ch);
	
	dirROI =  dir_save_fov_ch + "ROI/";
	dirKymo = dir_save_fov_ch + "Kymo/";
	File.makeDirectory(dirROI);
	File.makeDirectory(dirKymo);
	
	dir_file = dir_folder+fov+"_"+channel;	
	/*following file format:
	 * dir_folder>fov>
	 * 					$(fov)_channel1_name.tif
	 * 					$(fov)_channel2_name.tif
	 */
	 
	//open image file
	open(dir_file+".tif");
	name = getTitle();
	
	//extract trenches
	selectWindow(name);
	for (i=0; i<n_trenches; i++) {
	    shift_x = floor(ROI_gap*i);
	    ROI_x = left_ROI_x+shift_x;
	    print(ROI_x);
	    makeRectangle(ROI_x, ROI_y, ROI_w, ROI_h);
	    run("Duplicate...", "duplicate");
	    name_ROI = fov+"_tr_"+i;
	    saveAs("Tiff", dirROI+name_ROI);
	    run("Make Montage...", "columns=180 rows=3 scale=1 label");
	    name_Kymo = fov+"_tr_"+i;
	    saveAs("Tiff", dirKymo+name_Kymo);
	 //Next round!
	     selectWindow(name);
	}
	run("Close All");
//}