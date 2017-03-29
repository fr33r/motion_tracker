//******************************************************//
//	This program was ran, compiled, and tested	//
//	on a mac in room 10 in Benton Hall using	//
//	  Processing 2.1 and a built in camera.		//
//							//
//			.ZIP CONTENTS			//
//							//
//freerjm_CSE464_Motion_Tracking.pde			//
//freerjm_CSE464_Motion_Tracking_Video_Without_Path.mov //
//freerjm_CSE464_MOtion_Tracking_Video_With_Path.mov    //
//modelimages --> Directory. 				//
//videoframes --> Directory.				//
//README.txt  --> You're reading it.			//
//******************************************************//
//							//
//			INSTRUCTIONS			//
//							//
//	There are two "modes" of use for this software. //
//	The first mode has a rectangle following the	//
//	object being tracked. The second mode shows a 	//
//	path that the object has traveled in addition	//
//	to the rectangle that is present in the first	//
//	mode. Boolean flags at the top of the file	//
//	toggle this functionality. 			//
//							//
//	A boolean flag also can control whether or not	//
//	each frame is saved. This is used to create	//
//	video. The software runs slightly slower	//
//	when saving frames.				//
//							//
//	The default for these settings (for the turn	//
//	in) are going to be the following:		//
//							//
//	 - Display Path - Yes.				//
//	 - Save Frames - No.				//
//							//
//	The demonstrational videos have .mov file 	//
//	extensions and should be played via Quicktime	//
//	for the best quality.				//
//							//
//	The model of the ice hockey arena was created 	//
//	for the sole purpose of demonstration and is 	//
//	not to scale. It is available for turn-in upon	//
//	request.					//
//							//
//******************************************************//
//							//
//		STATEMENT OF ORIGINALITY		//
//							//
//	I, Jon Freer, wrote all of the code present	//
//	in this software. The techniques used were	//
//	discussed in my research paper and were		//
//	demonstrated in two separate tennis systems.	//
//							//
//	In order to become acquanted with Processing	//
//	and the API associated with it, I referenced	//
//	online API documentation.			//
//							//
//******************************************************//
//							//
//		     SOFTWARE PURPOSE			//
//							//
//	The purpose of this software is to track	//
//	the motion of an object regardless of		//
//	background. A rectangle of predetermined size	//
//	will encompass the moving object at all times.	//
//	If the path is chosen to be displayed, a path	//
//	will also be created to illustrate the path of	//
//	the moving object.				//
//							//
//	To relate to the initial interest of the 	//
//	project, the software will track a "puck"	//
//	in an ice rink (model).				//
//							//
//******************************************************//
//							//
//		     SOFTWARE OUTCOME			//
//							//
//	This software is capable of performing 		//
//	everything it was purposed for. This system	//
//	tracks the moving object accurately and 	//
//	efficiently. A rectangle of predetermined	//
//	size tracks the object and does not confuse	//
//	small background changes for the object.	//
//							//
//	The software performs the following:		//
//							//
//	   1) Creates a change mask (right).		//
//	   2) Creates a background image at the 30th	//
//	      frame.					//
//	   3) Perform simple differencing change	//
//	      detection algorithm to update change	//
//	      mask and segment the moving objects.	//
//	   4) Encapsulate the largest (most significant)//
//	      moving object.				//
//            with a rectangle.				//
//         5) Keep track of where the object has been	//
//            and draw path.				//
//	   6) Can save frames so that a video of its	//
//	      performance can be saved.			//
//							//
//******************************************************//
	