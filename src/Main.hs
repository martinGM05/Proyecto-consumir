{-# LANGUAGE OverloadedStrings #-}


module Main where

import           Network.HTTP.Simple            ( httpBS, getResponseBody, parseRequest ) -- Se agregó el paquete parseRequest para poder parsear.
import           Control.Lens                   ( preview )
-- Se agregan algunas indicaciones de tipo de dato para poder tratar los datos sin errores de salida
import           Data.Aeson.Lens                ( key, _Integer, _String, _Array)
import qualified Data.ByteString.Char8         as BS
import           Data.Text                      ( Text )
import qualified Data.Text.IO                  as TIO
import Data.Aeson

-- Este método obtiene el JSON de la API de la temperatura el cual solo necesita como parametro el lugar que queremos saber su clima
getJSONTemperature :: String  -> IO BS.ByteString -- Es la declaración de los tipos de dato del método
getJSONTemperature place = do
  -- Se guarda la API junto con el lugar en una variable para poder concatenar
  let urlWithPlace = ("http://api.weatherstack.com/current?access_key=2e0be873cbcc39085a15bea465c0ecc6&query=" Prelude.++  place)
  -- Se parsea la variable para poder consumir la api
  request <- parseRequest urlWithPlace 
  -- Se consume la API, en la variable resTemperature guardamos los datos
  resTemperature <- httpBS request
  -- Regresamos el cuerpo de los datos con la ayuda del método getResposeBody de la librería Network.HTTP.Simple 
  return (getResponseBody resTemperature)

-- Se define el tipo de dato del método para tratar el dato que obtenemos
getTemperature :: BS.ByteString -> Maybe Integer
-- Especificamos que campo queremos solicitar de la API de temperatura
getTemperature = preview (key "current" . key "temperature" . _Integer)

-- Se define el método junto al tipo de dato del resultado
getJSONPlace :: String -> IO BS.ByteString
-- Este método obtiene el JSON de los lúgares con el nombre parecido que existen en el mundo con un límite de 5 lugares
getJSONPlace place = do
  -- Guardamos la url correspondiente para poder concatenarle el lugar a buscar
  let urlWithPlace = ("http://143.198.126.142:3000/api/v1/?place=" Prelude.++ place)
  -- Parseamos la url para poder consumirla
  request <- parseRequest urlWithPlace
  -- Consumimos la API
  resPlace <- httpBS request
  -- Regresamos el cuerpo de la respuesta
  return (getResponseBody resPlace)

-- Se define el tipo de dato que maneja el método
getPlace :: BS.ByteString -> Maybe Text
-- Especificamos el campo que queremos obtener
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
  place <- getLine -- Guardamos el lugar que el usuario quiere conocer la temperatura
  json2 <- getJSONPlace place -- Mandamos el lugar al método getJSONPlace para poder obtener todos los lugar con un nombre parecido

  case getPlace json2 of
    Nothing -> TIO.putStrLn "No se encontro ninguna coincidencia con el lugar buscado" -- En caso de que no se encuentre ningún lugar
    Just places -> putStrLn(show places) -- Se mostrarán los lugares

  putStrLn ">> Ingrese un lugar de la lista"
  ciudad <- getLine -- Obtenemos el lugar especificado 
  json <- getJSONTemperature place -- Mandamos el lugar al método getJSONTemperature el cual mandamos el lugar al método que obtiene la temperatura


  case getTemperature json of
    -- En caso de que no encuentr o no esté disponible la temperatura en la zona especificada
    Nothing -> TIO.putStr "No se pudo obtener la temperatura"
    -- Regresamos el temperatura del lugar que nos da la API
    Just temperature -> putStr("La temperatura en " Prelude.++ ciudad Prelude.++ " es de : " Prelude.++ show temperature Prelude.++ " grados centígrados.")