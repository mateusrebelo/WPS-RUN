# WPS-RUN

Automação do **WPS (WRF Preprocessing System)**: execução integrada de  
**geogrid → ungrib (ERA5 PLEV + SFC) → metgrid**.

Este repositório contém:

- `wps_run.sh` → script shell que roda todo o fluxo do WPS (geogrid + ungrib PLEV + ungrib SFC + metgrid)  
- `Download_era5_pressure_level.py` → script Python para download dos dados ERA5 em níveis de pressão  
- `Download_era5_single_level.py` → script Python para download dos dados ERA5 em superfície (single levels)  

---

## Pré-requisitos

- Linux (testado em Ubuntu 22.04)
- WPS compilado (geogrid.exe, ungrib.exe, metgrid.exe disponíveis)
- Python 3 + [cdsapi](https://cds.climate.copernicus.eu/api-how-to) configurado com sua conta Copernicus (`~/.cdsapirc`)
- CDO + ecCodes instalados (recomendado via conda-forge)

---

## Estrutura esperada de diretórios

```bash
Build_WRF/
└── WPS-4.5/
    ├── geogrid.exe
    ├── ungrib.exe
    ├── metgrid.exe
    ├── namelist.wps
    ├── GRIBS/
    │   ├── ERA5_PLEV/   # arquivos GRIB de níveis de pressão
    │   └── ERA5_SFC/    # arquivos GRIB de superfície
    ├── wps_run.sh
    ├── Download_era5_pressure_level.py
    └── Download_era5_single_level.py
