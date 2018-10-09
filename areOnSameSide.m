function answer = areOnSameSide(x1,y1,x2,y2,zaribX,zaribY,C)
    a1 = x1 * zaribX + y1 * zaribY + C;
    a2 = x2 * zaribX + y2 * zaribY + C;
    answer = 0;
    if(a1 * a2 >= 0)
        answer = 1;
    end
end