//params
nFOVs = 20;

dir_save = "C:/Users/student/Desktop/exp1_kymo/";						//where results will be stored
File.makeDirectory(dir_save);
channels = newArray("mCherry","YFP");

for(n_f = 0; n_f < nFOVs; n_f++){
	fov = "xy"+IJ.pad(n_f,3);
	print("starting "+fov);
	dir_save_fov = dir_save + fov+"/";
	File.makeDirectory(dir_save_fov);
	
	dir_folder = "C:/Users/student/Desktop/exp1_extract/"+fov +"/";		//folder where trench extraction was saved to
	
	//setup
	run("Close All");
	list = getFileList(dir_folder+channels[0]+"/Kymo/");
	n_tr = list.length;
	print("detected "+n_tr+" trenches");

	for(tr=0;tr<n_tr;tr++){
		for (c = 0; c < channels.length; c++) {
			channel=channels[c];
			open(dir_folder+channel+"/Kymo/"+fov+"_tr_"+tr+".tif");
			rename(channel);
		}
		run("Merge Channels...", "c1=mCherry c7=YFP create");
		saveAs("Tiff", dir_save+fov+"/"+fov+"_tr"+tr+".tif");
		run("Close All");
	}
}