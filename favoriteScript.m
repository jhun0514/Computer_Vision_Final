pathsift = './sift/';
pathframe = './frames/';
arrayIm = ['/friends_0000000998.jpeg'; '/friends_0000002832.jpeg'; '/friends_0000004884.jpeg'; '/friends_0000006161.jpeg'];

strIm = strcat(arrayIm(1,:), '.mat');
imDir = dir([pathsift strIm]);
nn = [pathsift '/' imDir.name];
load(nn, 'positions');

imshow(imread([pathframe arrayIm(1,:)]));
h = impoly(gca, []);
api = iptgetapi(h);
nextpos1 = api.getPosition();
ptsin = inpolygon(positions(:,1), positions(:,2), nextpos1(:,1), nextpos1(:,2));
oninds1 = find(ptsin==1);

strIm = strcat(arrayIm(2,:), '.mat');
imDir = dir([pathsift strIm]);
nn = [pathsift '/' imDir.name];
load(nn, 'positions');

imshow(imread([pathframe arrayIm(2,:)]));
h = impoly(gca, []);
api = iptgetapi(h);
nextpos2 = api.getPosition();
ptsin = inpolygon(positions(:,1), positions(:,2), nextpos1(:,1), nextpos1(:,2));
oninds2 = find(ptsin==1);

strIm = strcat(arrayIm(3,:), '.mat');
imDir = dir([pathsift strIm]);
nn = [pathsift '/' imDir.name];
load(nn, 'positions');

imshow(imread([pathframe arrayIm(3,:)]));
h = impoly(gca, []);
api = iptgetapi(h);
nextpos3 = api.getPosition();
ptsin = inpolygon(positions(:,1), positions(:,2), nextpos1(:,1), nextpos1(:,2));
oninds3 = find(ptsin==1);

strIm = strcat(arrayIm(4,:), '.mat');
imDir = dir([pathsift strIm]);
nn = [pathsift '/' imDir.name];
load(nn, 'positions');

imshow(imread([pathframe arrayIm(4,:)]));
h = impoly(gca, []);
api = iptgetapi(h);
nextpos4 = api.getPosition();
ptsin = inpolygon(positions(:,1), positions(:,2), nextpos1(:,1), nextpos1(:,2));
oninds4 = find(ptsin==1);

