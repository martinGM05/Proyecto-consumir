{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_consumir (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Martin Gonzalez\\Documents\\Escuela\\Tec\\Veranos Enero - Junio 2021\\Programaci\243n L\243gica y funcional\\Ejercicios\\consumir\\.stack-work\\install\\7a46dc15\\bin"
libdir     = "C:\\Users\\Martin Gonzalez\\Documents\\Escuela\\Tec\\Veranos Enero - Junio 2021\\Programaci\243n L\243gica y funcional\\Ejercicios\\consumir\\.stack-work\\install\\7a46dc15\\lib\\x86_64-windows-ghc-8.10.4\\consumir-0.1.0.0-LV18l01cuo4JSTZRG7dtbO-consumir"
dynlibdir  = "C:\\Users\\Martin Gonzalez\\Documents\\Escuela\\Tec\\Veranos Enero - Junio 2021\\Programaci\243n L\243gica y funcional\\Ejercicios\\consumir\\.stack-work\\install\\7a46dc15\\lib\\x86_64-windows-ghc-8.10.4"
datadir    = "C:\\Users\\Martin Gonzalez\\Documents\\Escuela\\Tec\\Veranos Enero - Junio 2021\\Programaci\243n L\243gica y funcional\\Ejercicios\\consumir\\.stack-work\\install\\7a46dc15\\share\\x86_64-windows-ghc-8.10.4\\consumir-0.1.0.0"
libexecdir = "C:\\Users\\Martin Gonzalez\\Documents\\Escuela\\Tec\\Veranos Enero - Junio 2021\\Programaci\243n L\243gica y funcional\\Ejercicios\\consumir\\.stack-work\\install\\7a46dc15\\libexec\\x86_64-windows-ghc-8.10.4\\consumir-0.1.0.0"
sysconfdir = "C:\\Users\\Martin Gonzalez\\Documents\\Escuela\\Tec\\Veranos Enero - Junio 2021\\Programaci\243n L\243gica y funcional\\Ejercicios\\consumir\\.stack-work\\install\\7a46dc15\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "consumir_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "consumir_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "consumir_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "consumir_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "consumir_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "consumir_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
