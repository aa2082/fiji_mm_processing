//params
test = false;
nFOVs = 20;
if(test){nFOVs = 1;} //testing one FOV

dir_save = "C:/Users/ali/Desktop/exp1_seg_gif_with_roi/";						//where results will be stored
dir_trenches = "E:/exp1_extract/";
File.makeDirectory(dir_save);

seg_max_inten = 1300;
info_max_inten = 700;

run("Close All");
for(n_f = 0; n_f < nFOVs; n_f++){
	fov = "xy"+IJ.pad(n_f,3);
	print("starting "+fov);
	dir_folder = dir_trenches+fov +"/";		//folder where trench extraction was saved to
	
	dir_save_fov = dir_save + fov+"/";
	File.makeDirectory(dir_save_fov);
	
	//setup
	run("Close All");
	//channels = newArray("mCherry","YFP");
	seg_channel = "mCherry";
	info_channel = "YFP";
	list = getFileList(dir_folder+seg_channel+"/ROI/");
	n_tr = list.length;
	print("detected "+n_tr+" trenches");
	
	if(test){n_tr = 1;}  //testing just one trench
	for(tr=0;tr<n_tr;tr++){
		//CREATE FOLDERS
		dirMasks =  dir_save_fov + "Masks/";
		dirData = dir_save_fov + "Data/";
		File.makeDirectory(dirMasks);
		File.makeDirectory(dirData);
		
		open(dir_folder+seg_channel+"/ROI/"+fov+"_tr_"+tr+".tif");
		
		/*
		 * SEGMENTATION CODE START
		 */
		name = getTitle(); 
		
		// get stack dimensions
		Stack.getDimensions(w, h, c, slice, frame);
		// scale image 
		sc = 1.0;// scaling factor
		w_sc=w*sc;// width of scaled image
		h_sc=h*sc;//height of ...
		run("Scale...", "x="+sc+" y="+sc+" z=1.0 width="+w_sc+" height="+h_sc+" depth=slice interpolation=Bilinear average process create");
		
		// Thresholding to generate masks
		run("8-bit");
		run("Auto Local Threshold", "method=MidGrey radius=9 parameter_1=0 parameter_2=-1 white stack");
		// run watershed to separate the touching masks
		run("Invert", "stack");
		run("Options...", "iterations=2 count=2 do=Open stack");
		run("Options...", "iterations=2 count=2 do=Close stack");
		
		run("Adjustable Watershed", "tolerance=2.5 stack");
		
		// smoothing the mask outlines using repeated erosion and dilation

		run("Erode", "stack");
		run("Dilate", "stack");

		run("Invert", "stack");
		
		//SCALE DOWN
		sci = 1/sc;// scaling factor
		w_sci=w_sc*sci;// width of scaled image
		h_sci=h_sc*sci;//height of ...
		run("Scale...", "x="+sci+" y="+sci+" z=1.0 width="+w_sci+" height="+h_sci+" depth=slice interpolation=Bilinear average process create");
		run("Make Binary", "method=Default background=Dark calculate");
		
		//select masks of interest
		run("Analyze Particles...", "size=20-4000 circularity=0.00-1.00 show=Masks exclude clear add stack");   
		
		/*
		 * END OF SEGMENTATION - Have now obtained ROIs of interest
		 */


		 
		/*
		 *  EXTRACT DATA FROM SEG CHANNEL, SAVE GIF OF SEGMENTATION
		 */
		run("Close All");
		open(dir_folder+seg_channel+"/ROI/"+fov+"_tr_"+tr+".tif");
		
		// paramters to be extracted from the masks
		run("Clear Results");
		run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
		// Extract images from masks in ROI manager
		roiManager("Measure");
		saveAs("Results", dirData+"data_"+fov+"_tr_"+tr+"_"+seg_channel+".csv");
		/*
		 * SAVE TIF OF SEG CHANNEL WITH ROI highligths
		 */
		roiManager("Associate", "true");
		roiManager("Centered", "false");
		roiManager("UseNames", "false");
		run("Enhance Contrast", "saturated=0.35");
		setMinAndMax(0, seg_max_inten);
		//run("Brightness/Contrast...");
		run("8-bit");
		roiManager("Show All without labels");
		run("From ROI Manager");
		saveAs("Gif",dirMasks+"stack_"+fov+"_tr_"+tr+"_"+seg_channel+".gif");
		run("Close All");

		/*
		 *  EXTRACT DATA FROM INFO CHANNEL, SAVE GIF OF SEGMENTATION
		 */
		run("Close All");
		open(dir_folder+info_channel+"/ROI/"+fov+"_tr_"+tr+".tif");
		
		// paramters to be extracted from the masks
		run("Clear Results");
		run("Set Measurements...", "area mean standard modal min centroid center perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
		// Extract images from masks in ROI manager
		roiManager("Measure");
		saveAs("Results", dirData+"data_"+fov+"_tr_"+tr+"_"+info_channel+".csv");
		/*
		 * SAVE TIF OF SEG CHANNEL WITH ROI highligths
		 */
		roiManager("Associate", "true");
		roiManager("Centered", "false");
		roiManager("UseNames", "false");
		run("Enhance Contrast", "saturated=0.35");
		setMinAndMax(0, info_max_inten);
		//run("Brightness/Contrast...");
		run("8-bit");
		roiManager("Show All without labels");
		run("From ROI Manager");
		saveAs("Gif",dirMasks+"stack_"+fov+"_tr_"+tr+"_"+info_channel+".gif");
		run("Close All");
	}
}