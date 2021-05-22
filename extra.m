pathframe = './frames/';
pathsift = './sift/';
load('kMeansSaved.mat');
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

a = 1;
noHist = histograms;
b = size(noHist, 1);
c = size(noHist, 2);
stop = zeros(10,c);
histoOne = zeros(b,1);
for i=1:b
  hist = noHist(i, :);    
  totalhist = sum(hist);
  if totalhist ~= 0
    noHist(i, :)=hist/sum(hist);
  else 
    noHist(i, :)=0;
  end
end
newhistOne = zeros(b, 1);
for i=1:c
  nz = nnz(noHist(:,i));
  histoOne(i,1)=sum(noHist(:, i));
  if histoOne > 4000
    stop(a,:)=noHist(i,:);
    a = a + 1;
  end
  if nz
    newhistOne(i)=log(c/nz);
  end
end
for i=1:c
  noHist(:,i)=noHist(:,i)*newhistOne(i);
end
histograms = noHist;

arrayIm = ['/friends_0000000062.jpeg'; '/friends_0000000141.jpeg'; '/friends_0000006580.jpeg'];
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

[setA,setB,setC,nA,nB,nC] = deal([]);

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
  imname = [pathframe imname]; 

  histograM = histograms(i,:);

  allV = norm(arrayQ(1,:),'fro');
  newV = norm(histograM,'fro');
  aa = (arrayQ(1,:)*histograM')/(allV * newV);
  
  setA = cat(1,setA,aa);
  nA = cat(1, nA, imname);
  
  allV = norm(arrayQ(2,:),'fro');
  newV = norm(histograM,'fro');
  bb = (arrayQ(2,:)*histograM')/(allV * newV);
  
  setB = cat(1,setB,bb);
  nB = cat(1, nB, imname);
  
  allV = norm(arrayQ(3,:),'fro');
  newV = norm(histograM,'fro');
  cc = (arrayQ(3,:)*histograM')/(allV * newV);
  
  setC = cat(1,setC,cc);
  nC = cat(1, nC, imname);
  
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


figure;
subplot(3,3,1);
imname = [pathframe arrayIm(1,:)];
im = imread(imname);
imshow(im);
title('Query Image');
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
for i = 1:size(sortC,1)
  n = i + 1;
  subplot(3,3,n);
  imshow(imread(sortC(i,:)));
  t = ['Rank ' int2str(i)];
  title(t);
end