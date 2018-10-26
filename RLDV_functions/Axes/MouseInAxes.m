

function [cursor,ax,limsAx] = MouseInAxes(fig)
axesHandles = findobj(fig,'type','axes') ;
ax = [] ;
cursor = [] ;
limsAx = [] ;
if (~isempty(axesHandles))
    for i = 1:length(axesHandles)
        cursor = axesHandles(i).CurrentPoint(1,1:2) ;
        limsAx = axis(axesHandles(i)) ;
        isIn = (cursor(1)>=limsAx(1)) && ...
                (cursor(1)<=limsAx(2)) && ...
                (cursor(2)>=limsAx(3)) && ...
                (cursor(2)<=limsAx(4)) ;
        if (isIn)
            ax = axesHandles(i) ;
            return ;
        end
    end
end