function show_skel_MHAD(data)
%   data[3JXT]: 3D skeletion data of J joints and T frames

J = [1,2,3,4,5,6,4,8,9,10,11,12,13,4,15,16,17,18,19,20,1,22,23,24,25,26,27,1,29,30,31,32,33,34
    2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35];


x = data(1:3:end,:);
y = data(2:3:end,:);
z = data(3:3:end,:);

T = size(data,2);

clf;



for t=1:T
    plot3(x(:,t),y(:,t),z(:,t),'o');
    
    set(gca,'DataAspectRatio',[1 1 1]);
    axis([min(min(x)) max(max(x)) min(min(y)) max(max(y)) min(min(z)) max(max(z))]);
    for j=1:34
        c1=J(1,j);
        c2=J(2,j);
        line([x(c1,t) x(c2,t)], [y(c1,t) y(c2,t)], [z(c1,t) z(c2,t)]);
    end    
%     title([num2str(t) '/' num2str(T)]);
%     axis tight;
    axis off;
%     view(-30,30);
    drawnow;
%     pause(0.1);
    t
    pause;
    35;
end

end

