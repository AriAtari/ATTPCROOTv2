Set(LIBRARY_NAME AtSeGAtest)
Set(LINKDEF AtSeGAtestyLinkDef.h)


set(SRCS
AtSeGAtestContFact.cxx
AtSeGAtestGeo.cxx
AtSeGAtestGeoPar.cxx
AtSeGAtest.cxx
AtSeGAtestPoint.cxx
)

Set(DEPENDENCIES
  FairRoot::Base
  ROOT::Core
  ATTPCROOT::AtSimulationData
)

generate_target_and_root_library(${LIBRARY_NAME}
  LINKDEF ${LINKDEF}
  SRCS ${SRCS}
  DEPS_PUBLIC ${DEPENDENCIES}
  )
