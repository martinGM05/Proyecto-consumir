{-# LANGUAGE OverloadedStrings #-}


module Main where

import           Network.HTTP.Simple            ( httpBS, getResponseBody, parseRequest )
import           Control.Lens                   ( preview )
import           Data.Aeson.Lens                ( key, _Integer, _String, _Array)
import qualified Data.ByteString.Char8         as BS
import           Data.Text                      ( Text )
import qualified Data.Text.IO                  as TIO

-- Importaciones además, agregar vector, aeson y unordered-containers en el archivo package.yaml
import Data.Aeson
import Data.Vector as V
import qualified Data.HashMap.Strict as HashMap

getJSONTemperature :: String  -> IO BS.ByteString
getJSONTemperature place = do
  let urlWithPlace = ("http://api.weatherstack.com/current?access_key=2e0be873cbcc39085a15bea465c0ecc6&query=" Prelude.++  place)
  request <- parseRequest urlWithPlace
  resTemperature <- httpBS request
  return (getResponseBody resTemperature)

getTemperature :: BS.ByteString -> Maybe Integer
getTemperature = preview (key "current" . key "temperature" . _Integer)

getJSONPlace :: String -> IO BS.ByteString
getJSONPlace place = do
  let urlWithPlace = ("http://143.198.126.142:3000/api/v1/?place=" Prelude.++ place)
  request <- parseRequest urlWithPlace
  resPlace <- httpBS request
  return (getResponseBody resPlace)

getPlace :: BS.ByteString -> Maybe Text
getPlace = preview (key "places" . _String)


main :: IO ()
main = do
  putStrLn "-------------------------------------------------------------------------------------------------------------------"
  putStrLn "-------------------------------------------------------------------------------------------------------------------"
  putStrLn "--------------------------Escribe el lugar del cual quieras saber la temperatura-----------------------------------"
  putStrLn "-------------------------------------------------------------------------------------------------------------------"
  putStrLn "-------------------------------------------------------------------------------------------------------------------"
  putStrLn "> "
  putStr ">> "
  place <- getLine
  json2 <- getJSONPlace place

  case getPlace json2 of
    Nothing -> TIO.putStrLn "No se encontro ninguna coincidencia con el lugar buscado"
    Just places -> putStrLn(show places)

  putStrLn ">> Ingrese un lugar de la lista"
  ciudad <- getLine
  json <- getJSONTemperature place 


  case getTemperature json of
    Nothing -> TIO.putStr "No se pudo obtener la temperatura"
    Just temperature -> putStr("La temperatura en " Prelude.++ ciudad Prelude.++ " es de : " Prelude.++ show temperature Prelude.++ " grados centígrados.")