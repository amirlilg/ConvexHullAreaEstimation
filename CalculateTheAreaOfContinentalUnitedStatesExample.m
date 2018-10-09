%% Calculate Geographic Area for Vector Data in Polygon Format
% This example shows how to calculate geographic areas for vector data in
% polygon format using the |areaint| function. |areaint| performs a
% numerical integration using Green's Theorem for the area on a surface
% enclosed by a polygon. Because this is a discrete integration on discrete
% data, the results are not exact. Nevertheless, the method provides the
% best means of calculating the areas of arbitrarily shaped regions. Better
% measures result from better data. For more information, see
% <docid:map_ref.br4uguf>.
%%
% Load the continental United States MAT-file, |conus.mat| , and calculate
% the radius of the Earth.

% Copyright 2015 The MathWorks, Inc.

load conus
earthradius = almanac('earth','radius');
%%
% Calculate the area of the continental United States, along with the area
% of Long Island and Martha's Vineyard. |areaint| like the other area
% functions, |areaquad| and |areamat|, returns the area as a fraction of the
% entire planet's surface, unless you provide a radius. Because the default
% Earth radius is in kilometers, the area is in square kilometers.
area = areaint(uslat,uslon,earthradius)
%%
% Calculate the areas of the Great Lakes using the same variables, this
% time in square miles. |areaint| returns three areas: the largest for the
% polygon representing Superior, Michigan, and Huron together, the other
% two for Erie and Ontario.
earthradius = almanac('earth','radius','miles');
area = areaint(gtlakelat,gtlakelon,earthradius)

