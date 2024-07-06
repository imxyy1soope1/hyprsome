use anyhow::{anyhow, Result};

pub struct Config {
    pub monitors: Vec<String>,
}

impl Config {
    pub fn parse(input: &str) -> Result<Config> {
        Ok(Config {
            monitors: input
                .parse::<toml::Table>()?
                .get("monitors")
                .ok_or(anyhow!("missing monitors"))?
                .as_array()
                .ok_or(anyhow!("expected array"))?
                .into_iter()
                .map(|name| name.as_str().map(ToString::to_string).ok_or(anyhow!("expected monitor name")))
                .collect::<Result<_>>()?,
        })
    }
}

