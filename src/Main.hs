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
  let urlWithPlace = ("https://api.mapbox.com/geocoding/v5/mapbox.places/"Prelude.++ place Prelude.++".json?access_token=pk.eyJ1IjoibWFydGluLWdvbnphbGV6IiwiYSI6ImNrcWR6amV3bTBheDkyb21sN2hjY254d3gifQ.-nVVQYwdS8-jkUTG2rmbDg&limit=5&language=es")
  request <- parseRequest urlWithPlace
  resPlace <- httpBS request
  return (getResponseBody resPlace)

getPlace :: BS.ByteString -> Maybe Value
getPlace = preview (key "features")

--getAnimes :: BS.ByteString -> [Vector Text]
getAnimes bs = do
  case eitherDecodeStrict' bs of
    Left e -> error e
    Right (Array array) -> do
      V.forM array $ \v ->
        case v of
          Object o ->
            case HashMap.lookup "place_name" o of
              Nothing -> error "Didn't find color key"
              Just (String c) -> return c
              Just v' -> error $ "Expected a String, got: " Prelude.++ show v'
          _ -> error $ "Expected an object, got: " Prelude.++ show v


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

  json2 <- getJSONPlace place -- Obtengo mi json que tiene un arreglo con el arreg
  let a = getPlace json2  -- obtengo el arreglo
  print(getAnimes a)  -- se manda al metodo la variable que contiene el arreglo

  -- case getPlace json2 of
  --   Nothing -> TIO.putStrLn "No se encontro ninguna coincidencia con el lugar buscado"
  --   Just features -> putStrLn(""++ show features)

  case getTemperature json of
    Nothing -> TIO.putStr "No se pudo obtener la temperatura"
    Just temperature -> putStr("La temperatura en " Prelude.++ place Prelude.++ " es de : " Prelude.++ show temperature)