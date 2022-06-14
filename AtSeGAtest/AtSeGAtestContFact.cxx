#include "AtSeGAtestContFact.h"

#include "AtSeGAtestGeoPar.h"

#include <FairContFact.h>
#include <FairRuntimeDb.h>

#include <TList.h>
#include <TString.h>

#include <cstring>

class FairParSet;

ClassImp(AtSeGAtestContFact)

   static AtSeGAtestContFact gAtSeGAtestContFact;

AtSeGAtestContFact::AtSeGAtestContFact() : FairContFact()
{
   /** Constructor (called when the library is loaded) */
   fName = "AtSeGAtestContFact";
   fTitle = "Factory for parameter containers in libAtSeGAtest";
   setAllContainers();
   FairRuntimeDb::instance()->addContFactory(this);
}

void AtSeGAtestContFact::setAllContainers()
{
   /** Creates the Container objects with all accepted
       contexts and adds them to
       the list of containers for the AtTpc library.
   */
   // NOLINTNEXTLINE (I think FairRoot owns this memory)
   auto *p = new FairContainer("AtSeGAtestGeoPar", "AtSeGAtest Geometry Parameters", "TestDefaultContext");
   p->addContext("TestNonDefaultContext");

   containers->Add(p);
}

FairParSet *AtSeGAtestContFact::createContainer(FairContainer *c)
{
   /** Calls the constructor of the corresponding parameter container.
       For an actual context, which is not an empty string and not
       the default context
       of this container, the name is concatinated with the context.
   */
   const char *name = c->GetName();
   FairParSet *p = nullptr;
   if (strcmp(name, "AtSeGAtestGeoPar") == 0) {
      p = new AtSeGAtestGeoPar(c->getConcatName().Data(), c->GetTitle(), c->getContext());
   }
   return p;
}
