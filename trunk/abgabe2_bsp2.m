imptest = importdata('segmentation.test',',');
impdata = importdata('segmentation.data',',');



kNNThis(1,imptest,impdata);
kNNThis(10,imptest,impdata);
kNNThis(20,imptest,impdata);