#!/usr/bin/env bash
# Automação WPS: geogrid + ungrib (ERA5 PLEV+SFC) + metgrid
########## IMORTANTE!!!! ##########
# Uso:
#   *1) Ajuste as variáveis abaixo <--
#   *2) Após salvar, transforme em executavel: chmod +x wps_run.sh <--
#   *3) Comando para exeutar o script: ./wps_run.sh <--
###################################

set -euo pipefail

########## CONFIGURAÇÕES ##########
# Raiz do WPS
WPS_DIR="/home/mateus_vnor/Build_WRF/WPS-4.5"

# Pastas onde estão os GRIBs
GRIB_PLEV_DIR="$WPS_DIR/GRIBS/ERA5_PLEV"
GRIB_SFC_DIR="$WPS_DIR/GRIBS/ERA5_SFC"

# Vtables
VTABLE_PLEV="$WPS_DIR/ungrib/Variable_Tables/Vtable.ERA-interim.pl"
VTABLE_SFC="$WPS_DIR/ungrib/Variable_Tables/Vtable.ECMWF"

# Sufixo de timestamp pros logs
TS="$(date +%Y%m%d_%H%M%S)"

# Logs
GEOGRID_LOG="$WPS_DIR/geogrid_$TS.log"
UNGRIB_PLEV_LOG="$WPS_DIR/ungrib_PLEV_$TS.log"
UNGRIB_SFC_LOG="$WPS_DIR/ungrib_SFC_$TS.log"
METGRID_LOG="$WPS_DIR/metgrid_$TS.log"
###################################

log() { echo -e "[$(date +%H:%M:%S)] $*"; }

cd "$WPS_DIR"

echo "============================================"
echo "  WPS – GEOGRID + UNGRIB (PLEV+SFC) + METGRID — $TS"
echo "============================================"

#########################
# 1) GEOGRID
#########################
log "Iniciando GEOGRID… (stdout+stderr em $GEOGRID_LOG)"
./geogrid.exe |& tee -a "$GEOGRID_LOG"
log "GEOGRID finalizado. Veja $GEOGRID_LOG"

#########################
# 2) UNGRIB – PLEV
#########################
log "Preparando UNGRIB (PLEV)… (stdout+stderr em $UNGRIB_PLEV_LOG)"
rm -f GRIBFILE.* Vtable ungrib.log FILE_PLEV:* E5PL:* 2>/dev/null || true
./link_grib.csh "$GRIB_PLEV_DIR"/*.grib
ln -sf "$VTABLE_PLEV" Vtable
./ungrib.exe |& tee -a "$UNGRIB_PLEV_LOG"

FIRST=$(ls -1 -- *:* 2>/dev/null | head -n1 || true)
if [[ -n "${FIRST:-}" ]]; then
  ORIG="${FIRST%%:*}"
  for f in "$ORIG":*; do
    [[ -f "$f" ]] || continue
    mv -- "$f" "FILE_PLEV:${f#"$ORIG":}"
  done
fi
log "Total FILE_PLEV:* = $(ls FILE_PLEV:* 2>/dev/null | wc -l)" | tee -a "$UNGRIB_PLEV_LOG"

#########################
# 3) UNGRIB – SFC
#########################
log "Preparando UNGRIB (SFC)… (stdout+stderr em $UNGRIB_SFC_LOG)"
rm -f GRIBFILE.* Vtable ungrib.log FILE_SFC:* E5SL:* 2>/dev/null || true
./link_grib.csh "$GRIB_SFC_DIR"/*.grib
ln -sf "$VTABLE_SFC" Vtable
./ungrib.exe |& tee -a "$UNGRIB_SFC_LOG"

FIRST=$(ls -1 -- *:* 2>/dev/null | head -n1 || true)
if [[ -n "${FIRST:-}" ]]; then
  ORIG="${FIRST%%:*}"
  for f in "$ORIG":*; do
    [[ -f "$f" ]] || continue
    mv -- "$f" "FILE_SFC:${f#"$ORIG":}"
  done
fi
log "Total FILE_SFC:* = $(ls FILE_SFC:* 2>/dev/null | wc -l)" | tee -a "$UNGRIB_SFC_LOG"

#########################
# 4) METGRID
#########################
log "Rodando METGRID… (stdout+stderr em $METGRID_LOG)"
./metgrid.exe |& tee -a "$METGRID_LOG"
log "METGRID finalizado. Veja $METGRID_LOG"

echo "============================================"
echo "  CONCLUÍDO: GEOGRID + UNGRIB (PLEV+SFC) + METGRID"
echo "  Logs:"
echo "    - $GEOGRID_LOG"
echo "    - $UNGRIB_PLEV_LOG"
echo "    - $UNGRIB_SFC_LOG"
echo "    - $METGRID_LOG"
echo "============================================"

