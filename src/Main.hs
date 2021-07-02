{-# LANGUAGE OverloadedStrings #-}


module Main where

import           Network.HTTP.Simple            ( httpBS, getResponseBody, parseRequest )
import           Control.Lens                   ( preview )
import           Data.Aeson.Lens                ( key, _Integer, _String)
import qualified Data.ByteString.Char8         as BS
import           Data.Text                      ( Text )
import qualified Data.Text.IO                  as TIO


getJSONTemperature :: String  -> IO BS.ByteString
getJSONTemperature place = do
  let urlWithPlace = ("http://api.weatherstack.com/current?access_key=2e0be873cbcc39085a15bea465c0ecc6&query=" ++  place)
  request <- parseRequest urlWithPlace
  resTemperature <- httpBS request
  return (getResponseBody resTemperature)

getTemperature :: BS.ByteString -> Maybe Integer
getTemperature = preview (key "current" . key "temperature" . _Integer)

getJSONPlace :: String -> IO BS.ByteString
getJSONPlace place = do
  let urlWithPlace = ("https://api.mapbox.com/geocoding/v5/mapbox.places/"++ place ++".json?access_token=pk.eyJ1IjoibWFydGluLWdvbnphbGV6IiwiYSI6ImNrcWR6amV3bTBheDkyb21sN2hjY254d3gifQ.-nVVQYwdS8-jkUTG2rmbDg&limit=5&language=es")
  request <- parseRequest urlWithPlace
  resPlace <- httpBS request
  return (getResponseBody resPlace)

getPlace :: BS.ByteString -> Maybe Text
getPlace = preview (key "features" . key "place_name")


main :: IO ()
main = do
  putStrLn "-------------------------------------------------------------------------------------------------------------------"
  putStrLn "-------------------------------------------------------------------------------------------------------------------"
  putStrLn "--------------------------Escribe el lugar del cual quieras saber la temperatura-----------------------------------"
  putStrLn "-------------------------------------------------------------------------------------------------------------------"
  putStrLn "-------------------------------------------------------------------------------------------------------------------"
  putStrLn "> "
  putStr "> "
  place <- getLine
  json <- getJSONTemperature place

  json2 <- getJSONPlace place
  print(json2)

  case getPlace json2 of
    Nothing -> TIO.putStrLn "No se encontro ninguna coincidencia con el lugar buscado"
    Just place_name -> putStrLn(""++ show place_name)

  case getTemperature json of
    Nothing -> TIO.putStr "No se pudo obtener la temperatura"
    Just temperature -> putStr("La temperatura en " ++ place ++ " es de : " ++ show temperature)
