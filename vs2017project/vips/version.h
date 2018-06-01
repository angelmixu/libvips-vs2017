/* Macros for the header version.
 */

#ifndef VIPS_VERSION_H
#define VIPS_VERSION_H

#define VIPS_VERSION		"8.6.3"
#define VIPS_VERSION_STRING	"8.6.3-Thu Mar  8 15:18:35 UTC 2018"
#define VIPS_MAJOR_VERSION	(8)
#define VIPS_MINOR_VERSION	(6)
#define VIPS_MICRO_VERSION	(3)

/* The ABI version, as used for library versioning.
 */
#define VIPS_LIBRARY_CURRENT	(50)
#define VIPS_LIBRARY_REVISION	(2)
#define VIPS_LIBRARY_AGE	(8)

/** 
 * VIPS_SONAME:
 *
 * The name of the shared object containing the vips library, for example
 * "libvips.so.42", or "libvips-42.dll".
 */

#include <vips/soname.h>

/* Not really anything to do with versions, but this is a handy place to put
 * it.
 */
#define VIPS_EXEEXT ".exe"
#define VIPS_ENABLE_DEPRECATED 1

#endif /*VIPS_VERSION_H*/
