# dbschema/default.esdl

module default {
  abstract type Auditable {
    property created_at -> datetime {
      readonly := true;
      default := datetime_current();
    }
  }

  abstract type Resolvable {
    required property resolved -> bool {
      default := false;
    };
    property resolved_at -> datetime {
      readonly := true;
      default := datetime_current();
    }
  }

  abstract type Notable_Design {
    required link comment -> Comment;
    required link dlux_design -> DLUX_Design;
  }


  type User extending Auditable {
    required property name -> str {
      constraint max_len_value(80);
    }
    required property username -> str {
      # usernames must be unique
      constraint exclusive;

      # max length (built-in)
      constraint max_len_value(25);
    };
    required property password -> str;
  }

  type DLUX_Design extending Auditable {
    required property key -> str {
      constraint max_len_value(80);
      constraint exclusive;
    }
    required property gestalt -> json;

  }

  type Comment extending Auditable, Resolvable {
    required property content -> str;
    required link author -> User;
    required link dlux_design -> DLUX_Design;
  }


  type Todo {
    required property created_at -> datetime {
      default := datetime_current();
    };
    required property created_by -> uuid;
    required property text -> str;
    required property done -> bool {
      default := false;
    };
  }
}
