randomNumber = 300;
pathframe = './frames/';
pathsift = './sift/';
allframe = dir([pathsift '/*.mat']);
[des, pos, sca, ori, fil] = deal([]);
for i=1:length(allframe)
  if (mod(i,25))
    continue;
  end
  name = [pathsift '/' allframe(i).name];
  load(name, 'imname', 'descriptors', 'positions', 'scales', 'orients');
  if size(descriptors,1) == 0
    continue;
  end
  randDes = randperm(size(descriptors,1));
  des = cat(1,des, descriptors(randDes(1:min([randomNumber,size(descriptors,1)])),:));
  pos = cat(1,pos, positions(randDes(1:min([randomNumber,size(descriptors,1)])),:));
  sca = cat(1,sca, scales(randDes(1:min([randomNumber,size(descriptors,1)]))));
  ori = cat(1,ori, orients(randDes(1:min([randomNumber,size(descriptors,1)]))));
  for j = 1:randomNumber
    fil = cat(1,fil,imname);
  end
end
[membership,means,rms] = kmeansML(1500,des');
kMeans = means';
zeroMean = zeros(size(means,2),1);
save('kMeans.mat', 'kMeans');
for i=1:length(membership)
  zeroMean(membership(i)) = zeroMean(membership(i))+1;
  [aa,bb] = max(zeroMean);
end
if (length(bb) >= 2)
  [aaa, bbb] = deal(aa(2), bb(2));
else
  [aaa,bbb] = max(zeroMean(zeroMean ~= aa));
end    
[bbset,bbbset] = deal(find(membership == bb),find(membership == bbb));
[finalbb,finalbbb] = deal([]);
[bbmean,bbbmean] = deal(means(:,bb)',means(:,bbb)');
for i = 1:length(bbset)
  [ndata, dimx] = size(bbmean);
  [ncentres, dimc] = size(des(bbset(i),:));
  if dimx ~= dimc
      error('Data dimension does not match dimension of centres')
  end
  n2 = (ones(ncentres, 1) * sum((bbmean.^2)', 1))' + ...
    ones(ndata, 1) * sum((des(bbset(i),:).^2)',1) - ...
    2.*(bbmean*(des(bbset(i),:)'));
  if any(any(n2<0))
    n2(n2<0) = 0;
  end
  e = [n2(1) bbset(i)];
  finalbb = cat(1,finalbb, e);
end
for i = 1:length(bbbset)
  [ndata, dimx] = size(bbbmean);
  [ncentres, dimc] = size(des(bbbset(i),:));
  if dimx ~= dimc
      error('Data dimension does not match dimension of centres')
  end
  n2 = (ones(ncentres, 1) * sum((bbbmean.^2)', 1))' + ...
    ones(ndata, 1) * sum((des(bbbset(i),:).^2)',1) - ...
    2.*(bbbmean*(des(bbbset(i),:)'));
  if any(any(n2<0))
    n2(n2<0) = 0;
  end
  e = [n2 bbbset(i)];
  finalbbb = cat(1,finalbbb, e);
end
finalbb = sort(finalbb);
finalbbb = sort(finalbbb);
[xone, yone] = size(finalbb(:,2));
[xtwo, ytwo] = size(finalbbb(:,2));
if (xone < 25 || xtwo < 25)
  error('Program could not find 25 matching patches for a random word. Run again.');
end
figure;
title('Figure 1');
for i = 1:25
  imname = [pathframe '/' fil(finalbb(i,2),:)];
  im = rgb2gray(imread(imname));
  display = getPatchFromSIFTParameters(pos(finalbb(i,2),:), sca(finalbb(i,2)), ori(finalbb(i,2)),im);
  subplot(5,5,i);
  imshow(display);
end
figure;
title('Figure 2');
for i = 1:25
  imname = [pathframe '/' fil(finalbbb(i,2),:)]; 
  im = rgb2gray(imread(imname));
  display = getPatchFromSIFTParameters(pos(finalbbb(i,2),:), sca(finalbbb(i,2)), ori(finalbbb(i,2)),im);
  subplot(5,5,i);
  imshow(display);
end