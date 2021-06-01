@jboss-eap-7 
Feature: EAP XP Openshift galleon s2i tests

Scenario: Test microprofile config.
    Given s2i build git://github.com/openshift/openshift-jee-sample from . with env and true using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,microprofile-openapi,microprofile-jwt,microprofile-fault-tolerance,-jpa,jpa-distributed,web-clustering  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |

Scenario: Test cloud-server, exclude open-tracing
    Given s2i build git://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-jaxrs with env and true
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,-open-tracing  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/eap/.galleon/provisioning.xml should contain value cloud-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/eap/.galleon/provisioning.xml should contain value open-tracing on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

Scenario: Test cloud-server, exclude open-tracing and observability
    Given failing s2i build git://github.com/openshift/openshift-jee-sample from . using master
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | cloud-server,-open-tracing,-observability  |

Scenario: Test jaxrs-server+observability, exclude open-tracing
    Given s2i build git://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-jaxrs with env and true
      | variable                             | value         |
      | GALLEON_PROVISION_LAYERS             | jaxrs-server,observability,-open-tracing  |
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/eap/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/eap/.galleon/provisioning.xml should contain value observability on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/eap/.galleon/provisioning.xml should contain value open-tracing on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name

Scenario: Test jaxrs-server+observability, exclude open-tracing from provisioning.xml
    Given s2i build git://github.com/jboss-container-images/jboss-eap-modules from tests/examples/test-app-jaxrs-exclude with env and true
    Then container log should contain WFLYSRV0025
    And check that page is served
      | property | value |
      | path     | /     |
      | port     | 8080  |
    Then XML file /opt/eap/.galleon/provisioning.xml should contain value jaxrs-server on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/eap/.galleon/provisioning.xml should contain value observability on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='include']/@name
    Then XML file /opt/eap/.galleon/provisioning.xml should contain value open-tracing on XPath //*[local-name()='installation']/*[local-name()='config']/*[local-name()='layers']/*[local-name()='exclude']/@name


