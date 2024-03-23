import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simup_up/enums/enums.dart';

class UserStations {
  static List<Station> stationList = [
    Station.palustre,
    Station.terminal,
    Station.cread,
    Station.fuente,
    Station.republica,
    Station.sanMateo,
    Station.toyota,
    Station.lomitas,
    Station.villa,
    Station.iglesia,
    Station.salud
  ];

  static List<String> stationNames(BuildContext context) => [
    AppLocalizations.of(context)!.palustre,
    AppLocalizations.of(context)!.terminal,
    AppLocalizations.of(context)!.cread,
    AppLocalizations.of(context)!.fuente,
    AppLocalizations.of(context)!.republica,
    AppLocalizations.of(context)!.sanMateo,
    AppLocalizations.of(context)!.toyota,
    AppLocalizations.of(context)!.lomitas,
    AppLocalizations.of(context)!.villa,
    AppLocalizations.of(context)!.iglesia,
    AppLocalizations.of(context)!.salud,
  ];

  static List<String> stationInfo(BuildContext context) => [
    AppLocalizations.of(context)!.palustreInfo,
    AppLocalizations.of(context)!.terminalInfo,
    AppLocalizations.of(context)!.creadInfo,
    AppLocalizations.of(context)!.fuenteInfo,
    AppLocalizations.of(context)!.republicaInfo,
    AppLocalizations.of(context)!.sanMateoInfo,
    AppLocalizations.of(context)!.toyotaInfo,
    AppLocalizations.of(context)!.lomitasInfo,
    AppLocalizations.of(context)!.villaInfo,
    AppLocalizations.of(context)!.iglesiaInfo,
    AppLocalizations.of(context)!.saludInfo,
  ];

  static List<String> stationAsset = [
    "assets/images/stations/palustre-cover.jpg",
    "assets/images/stations/terminal-cover.jpg",
    "assets/images/stations/cread-cover.jpg",
    "assets/images/stations/fuente-cover.jpg",
    "assets/images/stations/republica-cover.jpg",
    "assets/images/stations/sanMateo-cover.jpg",
    "assets/images/stations/toyota-cover.jpg",
    "assets/images/stations/lomitas-cover.jpg",
    "assets/images/stations/villa-cover.jpg",
    "assets/images/stations/iglesia-cover.jpg",
    "assets/images/stations/salud-cover.jpg"
  ];

  static List<List<Zone>> stationRoutes = [
    [Zone.libertad, Zone.bosch, Zone.playa, Zone.cundinamarca, Zone.latino, Zone.aeropuerto, Zone.salado, Zone.escobal, Zone.belen],
    [Zone.sanRafael, Zone.salado, Zone.antoniaSantos, Zone.trigal, Zone.toledo, Zone.torres, Zone.molinos, Zone.aeropuerto, Zone.rodeo],
    [Zone.trigal, Zone.aeropuerto, Zone.toledo, Zone.torres, Zone.salado],
    [Zone.sanLuis, Zone.aeropuerto, Zone.colsag, Zone.libertad, Zone.playa, Zone.escobal],
    [Zone.trigal, Zone.aeropuerto, Zone.toledo, Zone.torres, Zone.salado],
    [Zone.sanLuis, Zone.libertad, Zone.atalaya, Zone.libertad],
    [Zone.sanLuis, Zone.libertad, Zone.atalaya],
    [Zone.sanLuis, Zone.libertad, Zone.atalaya],
    [Zone.sanLuis, Zone.libertad, Zone.atalaya, Zone.bocono],
    [Zone.trigal, Zone.toledo, Zone.atalaya, Zone.aeropuerto, Zone.trigal, Zone.toledo, Zone.torres, Zone.molinos, Zone.salado],
    [Zone.trigal, Zone.toledo, Zone.atalaya, Zone.aeropuerto, Zone.trigal, Zone.toledo, Zone.torres, Zone.molinos, Zone.salado]
  ];
}