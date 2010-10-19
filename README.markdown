# Tunage

Tunage is a web application that allows you to search, display, and play tracks from your iTunes library in your browser. It runs on MarkLogic Server and Information Studio to load content and Application Builder to generate the basic application. You can download a free version of MarkLogic Server on the MarkLogic Developer Community.

## Information Studio
Information Studio is an easy new way to load information into a MarkLogic database. It includes a web-based UI as well as high-level APIs to collect, transform, and load content. 

## Application Builder
Application Builder allows you to build search applications without having to write any code. Application Builder gives you several ways to extend a built application. The most powerful means is to override the contents of the `/application/custom` directory with XQuery, CSS, and/or JavaScript. Once you’ve built your application with Application Builder the easiest way to edit the generated source code is to create a WebDAV app server. For an Application Builder application named `foobar`, Application Builder generates a `foobar-modules` database upon deployment. This database contains all of the code and assets that power the application. In the MarkLogic admin interface you can create a new WebDAV app server pointing to the `foobar-modules` database with a root of `/`, meaning the “root” database directory. Fire up your favorite WebDAV client and point it to the `http://host:port` that you just set up. Navigate to `/application/custom` and drag in the contents of the `Application Builder/application/custom` directory above.

