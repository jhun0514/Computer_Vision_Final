pathframe = './frames/';
pathsift = './sift/';
load('kMeansSaved.mat');
load('favorite.mat');
allframe = dir([pathsift '/*.mat']);
histograms = [];
for i=1:length(allframe) 
  kName = [pathsift '/' allframe(i).name];
  load(kName, 'descriptors');
  if (size(descriptors,1) > 0)
    distValue = dist2(descriptors, kMeans);
    [~, b] = min(distValue,[],2);
    [bcoun, ~] = histc(b, 1:1500);
    if (size(bcoun,1)==1)
      x = bcoun';
      bcoun = x;
    end
    ht = bcoun;
  else
    ht = zeros(1500, 1);
  end
  histograms = cat(1,histograms, ht');
end
arrayIm = ['/friends_0000000998.jpeg'; '/friends_0000002832.jpeg'; '/friends_0000004884.jpeg'; '/friends_0000006161.jpeg'];
arrayQ = [];
strIm = strcat(arrayIm(1,:), '.mat');
imDir = dir([pathsift strIm]);
nn = [pathsift '/' imDir.name];
load(nn, 'descriptors');
done = descriptors(oninds1,:);
distValue = dist2(done, kMeans);
[~, b] = min(distValue,[],2);
[bcoun, ~] = histc(b, 1:1500);
if (size(bcoun,1)==1)
x = bcoun';
bcoun = x;
end
ht = bcoun;
arrayQ = cat(1,arrayQ,ht');
strIm = strcat(arrayIm(2,:), '.mat');
imDir = dir([pathsift strIm]);
nn = [pathsift '/' imDir.name];
load(nn, 'descriptors');
dtwo = descriptors(oninds2,:);
distValue = dist2(dtwo, kMeans);
[~, b] = min(distValue,[],2);
[bcoun, ~] = histc(b, 1:1500);
if (size(bcoun,1)==1)
x = bcoun';
bcoun = x;
end
ht = bcoun;
arrayQ = cat(1,arrayQ,ht');
strIm = strcat(arrayIm(3,:), '.mat');
imDir = dir([pathsift strIm]);
nn = [pathsift '/' imDir.name];
load(nn, 'descriptors');
dthree = descriptors(oninds3,:);
distValue = dist2(dthree, kMeans);
[~, b] = min(distValue,[],2);
[bcoun, ~] = histc(b, 1:1500);
if (size(bcoun,1)==1)
x = bcoun';
bcoun = x;
end
ht = bcoun;
arrayQ = cat(1,arrayQ,ht');
strIm = strcat(arrayIm(4,:), '.mat');
imDir = dir([pathsift strIm]);
nn = [pathsift '/' imDir.name];
load(nn, 'descriptors');
dfour = descriptors(oninds4,:);
distValue = dist2(dfour, kMeans);
[~, b] = min(distValue,[],2);
[bcoun, ~] = histc(b, 1:1500);
if (size(bcoun,1)==1)
x = bcoun';
bcoun = x;
end
ht = bcoun;
arrayQ = cat(1,arrayQ,ht');
[setA,setB,setC,setD, nA,nB,nC, nD] = deal([]);
for i=1:length(allframe) 
  nn = [pathsift '/' allframe(i).name];
  load(nn, 'imname', 'descriptors');
  if size(descriptors,1) == 0
    continue;
  end
  if strcmp(arrayIm(1,:), imname)
      continue;
  end
  if strcmp(arrayIm(2,:), imname)
      continue;
  end
  if strcmp(arrayIm(3,:), imname)
      continue;
  end
  if strcmp(arrayIm(4,:), imname)
      continue;
  end
  imname = [pathframe imname]; 
  histograM = histograms(i,:);
  allV = norm(arrayQ(1,:),'fro');
  newV = norm(histograM,'fro');
  aa = (arrayQ(1,:)*histograM')/(allV * newV);
  if (aa > 0)
    setA = cat(1,setA,aa);
    nA = cat(1, nA, imname);
  end
  allV = norm(arrayQ(2,:),'fro');
  newV = norm(histograM,'fro');
  bb = (arrayQ(2,:)*histograM')/(allV * newV);
  if (bb > 0)
    setB = cat(1,setB,bb);
    nB = cat(1, nB, imname);
  end
  allV = norm(arrayQ(3,:),'fro');
  newV = norm(histograM,'fro');
  cc = (arrayQ(3,:)*histograM')/(allV * newV);
  if (cc > 0)
    setC = cat(1,setC,cc);
    nC = cat(1, nC, imname);
  end
  allV = norm(arrayQ(4,:),'fro');
  newV = norm(histograM,'fro');
  cc = (arrayQ(4,:)*histograM')/(allV * newV);
  if (cc > 0)
    setD = cat(1,setD,cc);
    nD = cat(1, nD, imname);
  end
end
[~, index] = sort(setA, 'descend');
sortA = [];
for i = 1:5
    n = nA(index(i),:);
    sortA = cat(1,sortA,n);
end
[~, index] = sort(setB, 'descend');
sortB = [];
for i = 1:5
    n = nB(index(i),:);
    sortB = cat(1,sortB,n);
end
[~, index] = sort(setC, 'descend');
sortC = [];
for i = 1:5
    n = nC(index(i),:);
    sortC = cat(1,sortC,n);
end
[~, index] = sort(setD, 'descend');
sortD = [];
for i = 1:5
    n = nD(index(i),:);
    sortD = cat(1,sortD,n);
end
figure;
subplot(3,3,1);
imname = [pathframe arrayIm(1,:)];
im = imread(imname);
imshow(im);
title('Query Image');
hold on;
none = nextpos1(:,1);
ntwo = nextpos1(:,2);
h = fill(none,ntwo, 'r');
set(h, 'FaceColor','none');
set(h, 'EdgeColor','y');
set(h, 'LineWidth',4);
for i = 1:size(sortA,1)
  n = i + 1;
  subplot(3,3,n);
  g = imread(sortA(i,:));
  imshow(g);
  t = ['Rank ' int2str(i)];
  title(t);
end
figure;
subplot(3,3,1);
imname = [pathframe arrayIm(2,:)];
imshow(imread(imname));
title('Query Image');
hold on;
none = nextpos2(:,1);
ntwo = nextpos2(:,2);
h = fill(none,ntwo, 'r');
set(h, 'FaceColor','none');
set(h, 'EdgeColor','y');
set(h, 'LineWidth',4);
for i = 1:size(sortB,1)
  n = i + 1;
  subplot(3,3,n);
  imshow(imread(sortB(i,:)));
  t = ['Rank ' int2str(i)];
  title(t);
end
figure;
subplot(3,3,1);
imname = [pathframe arrayIm(3,:)];
imshow(imread(imname));
title('Query Image');
hold on;
none = nextpos3(:,1);
ntwo = nextpos3(:,2);
h = fill(none,ntwo, 'r');
set(h, 'FaceColor','none');
set(h, 'EdgeColor','y');
set(h, 'LineWidth',4);
for i = 1:size(sortC,1)
  n = i + 1;
  subplot(3,3,n);
  imshow(imread(sortC(i,:)));
  t = ['Rank ' int2str(i)];
  title(t);
end
figure;
subplot(3,3,1);
imname = [pathframe arrayIm(4,:)];
imshow(imread(imname));
title('Query Image');
hold on;
none = nextpos4(:,1);
ntwo = nextpos4(:,2);
h = fill(none,ntwo, 'r');
set(h, 'FaceColor','none');
set(h, 'EdgeColor','y');
set(h, 'LineWidth',4);
for i = 1:size(sortD,1)
  n = i + 1;
  subplot(3,3,n);
  imshow(imread(sortD(i,:)));
  t = ['Rank ' int2str(i)];
  title(t);
end