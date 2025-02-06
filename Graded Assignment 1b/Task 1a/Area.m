function A = Area(x1, y1, x2, y2, x3, y3)

A = 1/2 * det([x1, y1, 1; x2, y2, 1; x3, y3, 1]);

end