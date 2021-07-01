{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Network.HTTP.Simple            ( httpBS, getResponseBody )
import           Control.Lens                   ( preview )
import           Data.Aeson.Lens                ( key, _Integer )
import qualified Data.ByteString.Char8         as BS
import           Data.Text                      ( Text )
import qualified Data.Text.IO                  as TIO

main :: IO ()
main = do
  let url = "http://api.weatherstack.com/current?access_key=2e0be873cbcc39085a15bea465c0ecc6&query="
  putStrLn "Escribe el lugar del cual quieras saber la temperatura"
  a <- getLine
  let urlWithPlace = (url ++ a)
  json <- fetchJSON(urlWithPlace)
  case getTemperature json of
    Nothing -> TIO.putStr "No se pudo obtener la temperatura"
    Just temperature -> putStr("La temperatura en " ++ a ++ " es de : " ++ show temperature)

--fetchJSON :: IO BS.ByteString
fetchJSON(urlWithPlace) = do
  resTemperature <- httpBS urlWithPlace
  return (getResponseBody resTemperature)

getTemperature :: BS.ByteString -> Maybe Integer
getTemperature = preview (key "current" . key "temperature" . _Integer)
 

