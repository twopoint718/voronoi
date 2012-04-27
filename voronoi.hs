{-
Voronoi Diagrams

Copyright 2012, Chris Wilson <christopher.j.wilson@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
-}

import Data.List (sort, sortBy, groupBy, nub, intercalate)
import Data.Map (Map, fromList)
import Data.Ord (comparing)
import qualified Data.Map as M
import Data.Maybe

data Point = P Int Int deriving (Ord, Eq, Read)

newtype Distance = D Int deriving (Ord, Eq, Show)

type Region = [(Point, Point)]
type Color = [Int]

main = do
    dims <- readFile "dims.txt" >>= return . words
    let h = read (head dims) :: Int
    let w = read (head (tail dims)) :: Int
    vertexLines <- readFile "points.txt" >>= return . lines
    let verts = map read vertexLines :: [Point]
    putStrLn $ render $ rasterRegion verts h w

distance (P ax ay) (P bx by) = (ax - bx)^2 + (ay - by)^2

-- given a raster point (a point in the output image) find the vertex
-- that it is closest to.
nearest :: Point -> [Point] -> Point
nearest p vertices = snd $ head sortedDists
  where
    sortedDists = sortBy (comparing fst) $ zip distances vertices
    distances = map (distance p) vertices

grid :: Int -> Int -> [Point]
grid h w = [P i j | i <- [0..h-1], j <- [0..w-1]]

--
-- rendering stuff
--

-- Voronoi diagrams are really pretty simple. For each point in the
-- image, find the vertex for which that point is closer than any
-- other vertex `(nearest rp vertices)`. For all the raster points
-- that are grouped with that same vertex, color them the same color.
rasterRegion :: [Point] -> Int -> Int -> Region
rasterRegion vertices h w = [(nearest rp vertices, rp) | rp <- grid h w]

colors :: [Color]
colors = -- thanks: http://blog.xkcd.com/2010/05/03/color-survey-results/
  [
    [0x7e, 0x1e, 0x9c] -- purple
  , [0x15, 0xb0, 0x1a] -- green
  , [0x03, 0x43, 0xdf] -- blue
  , [0xff, 0x81, 0xc0] -- pink
  , [0x65, 0x37, 0x00] -- brown
  , [0xe5, 0x00, 0x00] -- red
  , [0x95, 0xd0, 0xfc] -- lightblue
  , [0xf9, 0x73, 0x06] -- orange
  , [0xff, 0xff, 0x14] -- yellow
  , [0xbf, 0x77, 0xf6] -- light purple
  , [0xce, 0xa2, 0xfd] -- lilac
  ]

colorMap :: Region -> Map Point Color
colorMap region = fromList $ zip (nub $ map fst region) $ cycle colors

rpToDims (P x y) = show (x+1) ++ " " ++ show (y+1)

render :: Region -> String
render r = "P3\n" ++ size ++ "\n" ++ "255 255 255\n" ++ (intercalate " " $ colorize r)
  where
    size = rpToDims $ maximum $ map snd r

    colorize :: Region -> [String]
    colorize r = map getColor r

    colors :: Map Point Color
    colors = colorMap r

    getColor :: (Point, Point) -> String
    getColor (vert, xy) = case M.lookup vert colors of
      Nothing -> ""
      Just c  -> intercalate " " (map show c)
