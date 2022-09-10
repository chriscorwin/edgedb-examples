CREATE MIGRATION m1nvelw64n2c4t35zywyklgtubudlnqmbi5y6rbc36pyyln3kezovq
    ONTO m1m64sdjz2lvcla6w3as4cwo7orqkhj4avxw4qzfyemfoczqfpomsa
{
  CREATE ABSTRACT TYPE default::Auditable {
      CREATE PROPERTY created_at -> std::datetime {
          SET default := (std::datetime_current());
          SET readonly := true;
      };
  };
  CREATE TYPE default::DLUX_Design EXTENDING default::Auditable {
      CREATE REQUIRED PROPERTY gestalt -> std::json;
      CREATE REQUIRED PROPERTY key -> std::str {
          CREATE CONSTRAINT std::exclusive;
          CREATE CONSTRAINT std::max_len_value(80);
      };
  };
  CREATE ABSTRACT TYPE default::Resolvable {
      CREATE REQUIRED PROPERTY resolved -> std::bool {
          SET default := false;
      };
      CREATE PROPERTY resolved_at -> std::datetime {
          SET default := (std::datetime_current());
          SET readonly := true;
      };
  };
  CREATE TYPE default::User EXTENDING default::Auditable {
      CREATE REQUIRED PROPERTY name -> std::str {
          CREATE CONSTRAINT std::max_len_value(80);
      };
      CREATE REQUIRED PROPERTY paswword -> std::str;
      CREATE REQUIRED PROPERTY username -> std::str {
          CREATE CONSTRAINT std::exclusive;
          CREATE CONSTRAINT std::max_len_value(25);
      };
  };
  CREATE TYPE default::Comment EXTENDING default::Auditable, default::Resolvable {
      CREATE REQUIRED LINK author -> default::User;
      CREATE REQUIRED LINK dlux_design -> default::DLUX_Design;
      CREATE REQUIRED PROPERTY content -> std::str;
  };
  CREATE ABSTRACT TYPE default::Notable_Design {
      CREATE REQUIRED LINK comment -> default::Comment;
      CREATE REQUIRED LINK dlux_design -> default::DLUX_Design;
  };
};
