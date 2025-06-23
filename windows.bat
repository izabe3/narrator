@echo off
  setlocal enabledelayedexpansion

  REM Check if Docker is installed
  where docker >nul 2>nul
  if %errorlevel% neq 0 (
      echo Docker is not installed or not in the system PATH.
      pause
      exit /b 1
  )

  REM Check if Docker is running
  docker info >nul 2>&1
  if %errorlevel% neq 0 (
      echo Docker Desktop is not running. Please start Docker and try again.
      pause
      exit /b 1
  )

  REM Check if the Docker image exists
  docker image inspect narrator_backend:latest >nul 2>&1
  if %errorlevel% neq 0 (
      echo Docker image not found. Building the images...
      docker-compose build
  )

  REM Check if .env file exists
  if not exist "narrator_backend\.env" (
      echo .env file not found. Creating one...

      echo Please provide the following information:
      set /p openrouter_key="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"
      set /p sd_key="sk-mUCMQ1i1KWaVt2mVnLxtdMKIanEsK4z0GhHKcQ3429y74RGb"
      set /p FAL_KEY_SECRET="f4ac42e8-0936-4e4c-b5d0-16c5515f80f5:5846ffeedcc518956305976034b91da9"

      REM Write user input to .env file
      (
          echo openrouter_key=!openrouter_key!
          echo sd_key=!sd_key!
          echo FAL_KEY_SECRET=!FAL_KEY_SECRET!
      ) > "narrator_backend\.env"
  )

  REM Run docker-compose up
  echo Starting the application...
  docker-compose up

  REM After docker-compose up exits
  echo Shutting down the application...
  docker-compose down

  endlocal
  pause
