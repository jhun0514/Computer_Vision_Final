tframe = 'twoFrameData.mat';
load(tframe, 'im1', 'im2', 'descriptors1', 'descriptors2', 'positions1', 'positions2', 'scales1', 'scales2', 'orients1', 'orients2');
imshow(im1);
h = impoly(gca, []);
api = iptgetapi(h);
nextpos = api.getPosition();
ptsin = inpolygon(positions1(:,1), positions1(:,2), nextpos(:,1), nextpos(:,2));
oninds = find(ptsin==1);
none = nextpos(:,1);
ntwo = nextpos(:,2);
imshow(im1);
hold on;
h = fill(none,ntwo, 'r');
set(h, 'FaceColor','none');
set(h, 'EdgeColor','y');
set(h, 'LineWidth',4);

result = [];
for i = 1:size(oninds,1)
  ind1 = oninds(i);
  done = descriptors1;
  dtwo = descriptors2;
  x = done(ind1,:);
  c = dtwo;
  [ndata, dimx] = size(x);
  [ncentres, dimc] = size(c);
  if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
  end
  n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
    ones(ndata, 1) * sum((c.^2)',1) - ...
    2.*(x*(c'));
  if any(any(n2<0))
    n2(n2<0) = 0;
  end
  [a,b] = min(n2);
  d = min(n2(n2~=a(1)));
  ab = a/d;
  if (ab < 0.5)    
    result = cat(1,result,b(1));
  end
end
figure;
imshow(im2);
displaySIFTPatches(positions2(result,:), scales2(result), orients2(result), im2);