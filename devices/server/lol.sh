#!/bin/sh

read -p "Enter Overleaf Project Name [overleaf]: " input_project
PROJECT_NAME=${input_project:-overleaf}
echo $PROJECT_NAME
