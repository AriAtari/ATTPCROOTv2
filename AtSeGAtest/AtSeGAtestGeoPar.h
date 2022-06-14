#ifndef AtSEGATESTGEOPAR_H
#define AtSEGATESTGEOPAR_H

#include <FairParGenericSet.h>

#include <Rtypes.h>

class TObjArray;
class FairParamList;
class TBuffer;
class TClass;
class TMemberInspector;

class AtSeGAtestGeoPar : public FairParGenericSet {
public:
   /** List of FairGeoNodes for sensitive  volumes */
   TObjArray *fGeoSensNodes;

   /** List of FairGeoNodes for sensitive  volumes */
   TObjArray *fGeoPassNodes;

   AtSeGAtestGeoPar(const char *name = "AtSeGAtestGeoPar", const char *title = "AtSeGAtest Geometry Parameters",
                   const char *context = "TestDefaultContext");
   ~AtSeGAtestGeoPar(void);
   void clear(void);
   void putParams(FairParamList *);
   Bool_t getParams(FairParamList *);
   TObjArray *GetGeoSensitiveNodes() { return fGeoSensNodes; }
   TObjArray *GetGeoPassiveNodes() { return fGeoPassNodes; }

private:
   AtSeGAtestGeoPar(const AtSeGAtestGeoPar &);
   AtSeGAtestGeoPar &operator=(const AtSeGAtestGeoPar &);

   ClassDef(AtSeGAtestGeoPar, 1)
};

#endif
