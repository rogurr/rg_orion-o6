/**
  DO NOT EDIT
  FILE auto-generated
  Module name:
    AutoGen.h
  Abstract:       Auto-generated AutoGen.h for building module or library.
**/

#ifndef _AUTOGENH_1B7DDF6A_9B42_4D63_A3C8_5A1E64E05E31
#define _AUTOGENH_1B7DDF6A_9B42_4D63_A3C8_5A1E64E05E31

#ifdef __cplusplus
extern "C" {
#endif

#include <PiDxe.h>

extern GUID  gEfiCallerIdGuid;
extern GUID  gEdkiiDscPlatformGuid;
extern CHAR8 *gEfiCallerBaseName;

#define EFI_CALLER_ID_GUID \
  {0x1B7DDF6A, 0x9B42, 0x4D63, {0xA3, 0xC8, 0x5A, 0x1E, 0x64, 0xE0, 0x5E, 0x31}}
#define EDKII_DSC_PLATFORM_GUID \
  {0x53cfca21, 0x0399, 0x4802, {0xa3, 0xc0, 0xe8, 0x64, 0x37, 0xa4, 0x21, 0x83}}

// Guids
extern EFI_GUID gEfiMdePkgTokenSpaceGuid;
extern EFI_GUID gEfiMdeModulePkgTokenSpaceGuid;
extern EFI_GUID gArmPlatformTokenSpaceGuid;
extern EFI_GUID gCixTokenSpaceGuid;
extern EFI_GUID gCixPlatformTokenSpaceGuid;
extern EFI_GUID gArmTokenSpaceGuid;

// Protocols
extern EFI_GUID gPcdProtocolGuid;
extern EFI_GUID gEfiPcdProtocolGuid;
extern EFI_GUID gGetPcdInfoProtocolGuid;
extern EFI_GUID gEfiGetPcdInfoProtocolGuid;

// Definition of SkuId Array
extern UINT64 _gPcd_SkuId_Array[];

// Definition of PCDs used in libraries is in AutoGen.c






#ifdef __cplusplus
}
#endif

#endif
