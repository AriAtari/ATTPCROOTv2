/********************************************************************************
 *    Copyright (C) 2014 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH    *
 *                                                                              *
 *              This software is distributed under the terms of the             *
 *         GNU Lesser General Public Licence version 3 (LGPL) version 3,        *
 *                  copied verbatim in the file "LICENSE"                       *
 ********************************************************************************/
#include "AtTpcGeoPar.h"

#include <FairParGenericSet.h>
#include <FairParamList.h>

#include <TObjArray.h>

ClassImp(AtTpcGeoPar)

   AtTpcGeoPar ::AtTpcGeoPar(const char *name, const char *title, const char *context)
   : FairParGenericSet(name, title, context), fGeoSensNodes(new TObjArray()), fGeoPassNodes(new TObjArray())
{
}

AtTpcGeoPar::~AtTpcGeoPar() = default;

void AtTpcGeoPar::clear()
{
   if (fGeoSensNodes) {
      delete fGeoSensNodes;
   }
   if (fGeoPassNodes) {
      delete fGeoPassNodes;
   }
}

void AtTpcGeoPar::putParams(FairParamList *l)
{
   if (!l) {
      return;
   }
   l->addObject("FairGeoNodes Sensitive List", fGeoSensNodes);
   l->addObject("FairGeoNodes Passive List", fGeoPassNodes);
}

Bool_t AtTpcGeoPar::getParams(FairParamList *l)
{
   if (!l) {
      return kFALSE;
   }
   if (!l->fillObject("FairGeoNodes Sensitive List", fGeoSensNodes)) {
      return kFALSE;
   }
   if (!l->fillObject("FairGeoNodes Passive List", fGeoPassNodes)) {
      return kFALSE;
   }
   return kTRUE;
}
