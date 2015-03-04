# jooq-jhipster-generator
[JOOQ](http://www.jooq.org) code generator that generates code to enable integration with [JHipster](http://jhipster.github.io/).

[See the JOOQ Code Gen docs](http://www.jooq.org/doc/3.5/manual/code-generation/ "codegen")

# Motivation

If you are a seasoned Java developer, you probably know about Hibernate and JPA.  JOOQ is a radical departure from
this way of thinking.  It is designed as a "database first" data access framework.  If you enjoy modeling using SQL (DDL),
then you will find the rest of the JOOQ experience to be pretty amazing.  If you have some time, you might enjoy seeing one of
Lukas Eder's [videos](https://vimeo.com/100090712).

JHipster is definitely pro-JPA (Hibernate).  So, if you are working with JHipster and you enjoy pure-JPA all the time, then
you may have no need for this plugin.  BUT, if you have a large, existing model that you wish to connect to a spiffy JHipster
web interface, read on.

JOOQ contains no [Spring](http://projects.spring.io/spring-framework/) dependencies that I am aware of.  JHipster is
built on [Spring Boot](http://projects.spring.io/spring-boot/), which brings with it a raft of dependencies, including Spring.

The built in [Java Generator](https://github.com/jOOQ/jOOQ/blob/master/jOOQ-codegen/src/main/java/org/jooq/util/JavaGenerator.java) works fine,
but I wanted to extend it so that it would generate a couple extra things:

 - AllJooqDaos.java : a class with all of the Jooq-generated DAOs in it, all wired up by Spring.  You may extend this class in your services or controllers
to gain direct access to JOOQ's data management power.

 - JooqDaoConfiguration.java : You should not have to use this directly.  It is a class that initialized JOOQ's DslContext and acts as a factory for the Dao implementations.  Note that JOOQ will generate
 the DAOs for you if you have configured the generator appropriately.

# Usage
This library does not replace JOOQ or its .  It simply contains an implementation of a code generator that
you can use with the existing JOOQ generator.

Key activities:

 1. Generate code by integrating the JooqJhipsterGenerator into your Maven build.  NOTE that this process relies on the
  existing jooq-codegen-maven plugin.  To be clear, the jooq-maven-plugin invokes the JooqJhipsterGenerator during your
  maven build.

 2. Add AllJooqDaos as a base class of whatever services/controllers you like.  From there, it is stock JOOQ development.

# Maven example

Below is a code block showing how I am using it in my environment.  The snippet below goes into your pom.xml file, within
the build>plugins element:

            <plugin>
                <!-- Specify the maven code generator plugin -->
                <groupId>org.jooq</groupId>
                <artifactId>jooq-codegen-maven</artifactId>
                <version>${jooq.version}</version>

                <!-- The plugin should hook into the generate goal -->
                <executions>
                    <execution>
                        <goals>
                            <goal>generate</goal>
                        </goals>
                    </execution>
                </executions>

                <!-- Manage the plugin's dependency. In this example, we'll use a PostgreSQL database -->
                <dependencies>
                    <dependency>
                        <groupId>org.postgresql</groupId>
                        <artifactId>postgresql</artifactId>
                        <version>${postgresql.version}</version>
                    </dependency>
                </dependencies>

                <!-- Specify the plugin configuration.
                     The configuration format is the same as for the standalone code generator -->
                <configuration>

                    <!-- JDBC connection parameters -->
                    <jdbc>
                        <driver>${jdbcDriverClass}</driver>
                        <url>${env.DATABASE_SHORT_URL}</url>
                        <user>${env.DATABASE_USER}</user>
                        <password>${env.DATABASE_PASS}</password>
                    </jdbc>

                    <!-- Generator parameters -->
                    <generator>
                        <generate>
                            <daos>true</daos>
                        </generate>
                        <name>com.app3.jjg.JooqJhipsterGenerator</name>
                        <database>
                            <name>org.jooq.util.postgres.PostgresDatabase</name>
                            <includes>.*</includes>
                            <excludes/>
                            <inputSchema>public</inputSchema>
                        </database>
                        <target>
                            <packageName>com.pr.jooq</packageName>
                            <directory>src/main/generated</directory>
                        </target>
                    </generator>
                </configuration>
            </plugin>

# Contact

Please feel free to [contact me](mailto:will.mitchell@gmail.com) if you have any questions about the plugin.