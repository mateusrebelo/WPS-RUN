#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 10 08:52:46 2025

@author: mateus_vnor
"""

import cdsapi

c = cdsapi.Client()

c.retrieve("reanalysis-era5-complete", {
    "class": "ea",
    "date": "2021-08-19/2021-08-20",
    "expver": "1",
    "levtype": "sfc",
    "param": "129.128/134.128/146.128/147.128/165.128/166.128/167.128/168.128",
    "stream": "oper",
    "time": "00:00:00/01:00:00/02:00:00/03:00:00/04:00:00/05:00:00/06:00:00/07:00:00/08:00:00/09:00:00/10:00:00/11:00:00/12:00:00/13:00:00/14:00:00/15:00:00/16:00:00/17:00:00/18:00:00/19:00:00/20:00:00/21:00:00/22:00:00/23:00:00",
    "type": "an",
    'format': 'netcdf',  # Formato de saída recomendado para processamento posterior
    'area': '-29.9/-53.7/-28.0/-52.7',  # Pequena área ao redor do ponto de interesse
}, "/home/mateus_vnor/reanalise/ERA5_surface.nc")