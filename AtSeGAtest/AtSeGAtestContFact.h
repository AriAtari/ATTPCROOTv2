#ifndef AtSEGATESTCONTFACT_H
#define AtSEGATESTCONTFACT_H

#include <FairContFact.h>

#include <Rtypes.h>

class FairParSet;
class TBuffer;
class TClass;
class TMemberInspector;

class AtSeGAtestContFact : public FairContFact {
private:
   void setAllContainers();

public:
   AtSeGAtestContFact();
   ~AtSeGAtestContFact() {}
   FairParSet *createContainer(FairContainer *);
   ClassDef(AtSeGAtestContFact, 0) // Factory for all AtTpc parameter containers
};

#endif
