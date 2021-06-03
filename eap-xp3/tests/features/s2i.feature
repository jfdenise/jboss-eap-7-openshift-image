@jboss-eap-7-tech-preview
Feature: Openshift EAP s2i tests

  # CLOUD-807
  # JDK 11 needs an extra dep for javax.annotations
  Scenario: Test if the container has the JavaScript engine available
    Given s2i build https://github.com/luck3y/openshift-examples from eap-tests/jsengine using openjdk-11
     | variable                                                         | value           |
     | GALLEON_PROVISION_LAYERS                   | cloud-server,ejb     |
    Then container log should contain Engine found: jdk.nashorn.api.scripting.NashornScriptEngine
    And container log should contain Engine class provider found.
    And container log should not contain JavaScript engine not found.
