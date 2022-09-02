module Main where

import Codec.Picture
import Data.List
import System.Environment

averageColor :: Image PixelRGBA8 -> PixelRGBA8
averageColor img = p
  where
    p = (\(r,g,b,a) -> PixelRGBA8 (round (r/n)) (round (g/n)) (round (b/n)) (round (a/n))) $
        foldl' (\(r1,g1,b1,a1) (r2,g2,b2,a2) -> ((((,,,) $! (r1+r2)) $! (g1+g2)) $! (b1+b2)) $! (a1+a2))
          (0 :: Double, 0 :: Double, 0 :: Double, 0 :: Double)
          [ (fromIntegral r, fromIntegral g, fromIntegral b, fromIntegral a)
          | y <- [0 .. imageHeight img - 1]
          , x <- [0 .. imageWidth img - 1]
          , let PixelRGBA8 r g b a = pixelAt img x y
          ]
    n = fromIntegral (imageHeight img) * fromIntegral (imageWidth img)

main :: IO ()
main = do
  [fname] <- getArgs
  Right dynImg <- readImage fname
  case dynImg of
    ImageRGBA8 img -> do
      let PixelRGBA8 r g b a = averageColor img
      putStrLn $ "color [0] " ++ show [r,g,b,a]