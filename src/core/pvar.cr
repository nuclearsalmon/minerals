module Minerals
  macro pvar(stmt)
    ({{ stmt }}).tap { |res|
      puts "`" + {{ stmt.stringify }}.lstrip("(").rstrip(")") + "`:\n  #{res.pretty_inspect}"
    }
  end

  macro pvar(*stmts)
    {% for stmt, _ in stmts %}
      Minerals.pvar stmt
    {% end %}
  end
end
