clear;
pathframe = './frames/';
pathsift = './sift/';
allframe = dir([pathsift '/*.mat']);
load('kMeans.mat');
allImg = dir([pathframe '/*.jpeg']);
iN = randperm(length(allframe),1);
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
maxNum=10;
arrayIm = ['/friends_0000004503.jpeg'; '/friends_0000000394.jpeg'];
firstShift = [pathsift '/friends_0000004503.jpeg.mat' ];
secondShift = [pathsift '/friends_0000000394.jpeg.mat' ];
arrayQ = [];
for i = 1:size(arrayIm,1)
  strIm = strcat(arrayIm(i,:), '.mat');
  imDir = dir([pathsift strIm]);
  nn = [pathsift '/' imDir.name];
  load(nn, 'descriptors');
  distValue = dist2(descriptors, kMeans);
  [~, b] = min(distValue,[],2);
  [bcoun, ~] = histc(b, 1:1500);
  if (size(bcoun,1)==1)
    x = bcoun';
    bcoun = x;
  end
  ht = bcoun;
  arrayQ = cat(1,arrayQ,ht');
end
[setA,setB,nA,nB] = deal([]);
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
  imname = [pathframe imname]; 
  histograM = histograms(i,:);
  allV = norm(arrayQ(1,:),'fro');
  newV = norm(histograM,'fro');
  aa = (arrayQ(1,:)*histograM')/(allV * newV);
  if (aa > 0.3)
    setA = cat(1,setA,aa);
    nA = cat(1, nA, imname);
  end
  allV = norm(arrayQ(2,:),'fro');
  newV = norm(histograM,'fro');
  bb = (arrayQ(2,:)*histograM')/(allV * newV);
  if (bb > 0.3)
    setB = cat(1,setB,bb);
    nB = cat(1, nB, imname);
  end
end
[~, index] = sort(setA, 'descend');
sortA = [];
for i = 1:10
    n = nA(index(i),:);
    sortA = cat(1,sortA,n);
end

[~, index] = sort(setB, 'descend');
sortB = [];
for i = 1:10
    n = nB(index(i),:);
    sortB = cat(1,sortB,n);
end
figure;
subplot(4,3,1);
imname = [pathframe arrayIm(1,:)];
im = imread(imname);
imshow(im);
title('Query Image');
for i = 1:size(sortA,1)
  n = i + 1;
  subplot(4,3,n);
  g = imread(sortA(i,:));
  imshow(g);
  t = ['Rank ' int2str(i)];
  title(t);
end
poin = [];
load(firstShift, 'deepFC7');
orig_deep = deepFC7;
for i = 1:length(allframe)
  framecm = [pathsift '/' allframe(i).name];
  load(framecm, 'deepFC7');
  if i ~= iN(1)
    result = dot(orig_deep, deepFC7) / (norm(orig_deep) * norm(deepFC7));
    poin = [poin ; result]; 
  else
    poin = [poin ; -1];
  end
end
poin(isnan(poin)) = -1;
[~, ind] = sort(poin, 'descend');
figure;
for i=1:maxNum
  subplot(4, 3, i);
  impath = [pathframe '/' allImg(ind(i)).name];
  im = imread(impath);
  imshow(im);
  if i == 1
    title('Query Image');
  else
    t = ['Deep Rank ' int2str(i)];
    title(t);
  end
end

figure;
subplot(4,3,1);
imname = [pathframe arrayIm(2,:)];
imshow(imread(imname));
title('Query Image');
for i = 1:size(sortB,1)
  n = i + 1;
  subplot(4,3,n);
  imshow(imread(sortB(i,:)));
  t = ['Rank ' int2str(i)];
  title(t);
end

poin = [];
load(secondShift, 'deepFC7');
orig_deep = deepFC7;
for i = 1:length(allframe)
  framecm = [pathsift '/' allframe(i).name];
  load(framecm, 'deepFC7');
  if i ~= iN(1)
    result = dot(orig_deep, deepFC7) / (norm(orig_deep) * norm(deepFC7));
    poin = [poin ; result]; 
  else
    poin = [poin ; -1];
  end
end
poin(isnan(poin)) = -1;
[~, ind] = sort(poin, 'descend');
figure;
for i=1:maxNum
  subplot(4, 3, i);
  impath = [pathframe '/' allImg(ind(i)).name];
  im = imread(impath);
  imshow(im);
  if i == 1
    title('Query Image');
  else
    t = ['Deep Rank ' int2str(i)];
    title(t);
  end
end