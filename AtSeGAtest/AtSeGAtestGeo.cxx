#include "AtSeGAtestGeo.h"

#include <FairGeoSet.h>

#include <cstdio>

ClassImp(AtSeGAtestGeo)

   // -----   Default constructor   -------------------------------------------
   AtSeGAtestGeo::AtSeGAtestGeo()
   : FairGeoSet()
{
   // Constructor
   // fName has to be the name used in the geometry for all volumes.
   // If there is a mismatch the geometry cannot be build.
   fName = "Ge";
   maxSectors = 0;
   maxModules = 10;
}

// -------------------------------------------------------------------------

const char *AtSeGAtestGeo::getModuleName(Int_t m)
{
   /** Returns the module name of AtSeGAtest number m
       Setting AtSeGAtest here means that all modules names in the
       ASCII file should start with AtSeGAtest otherwise they will
       not be constructed
   */
   sprintf(modName, "AtSeGAtest%i", m + 1);
   return modName;
}

const char *AtSeGAtestGeo::getEleName(Int_t m)
{
   /** Returns the element name of Det number m */
   sprintf(eleName, "AtSeGAtest%i", m + 1);
   return eleName;
}
