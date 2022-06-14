#include "AtSeGAtestGeoPar.h"

#include <FairParGenericSet.h>
#include <FairParamList.h>

#include <TObjArray.h>

ClassImp(AtSeGAtestGeoPar)

   AtSeGAtestGeoPar ::AtSeGAtestGeoPar(const char *name, const char *title, const char *context)
   : FairParGenericSet(name, title, context), fGeoSensNodes(new TObjArray()), fGeoPassNodes(new TObjArray())
{
}

AtSeGAtestGeoPar::~AtSeGAtestGeoPar() = default;

void AtSeGAtestGeoPar::clear()
{
   if (fGeoSensNodes) {
      delete fGeoSensNodes;
   }
   if (fGeoPassNodes) {
      delete fGeoPassNodes;
   }
}

void AtSeGAtestGeoPar::putParams(FairParamList *l)
{
   if (!l) {
      return;
   }
   l->addObject("FairGeoNodes Sensitive List", fGeoSensNodes);
   l->addObject("FairGeoNodes Passive List", fGeoPassNodes);
}

Bool_t AtSeGAtestGeoPar::getParams(FairParamList *l)
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
